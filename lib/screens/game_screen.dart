import 'dart:math';
import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import 'winner_screen.dart';

class GameScreen extends StatefulWidget {
  static const routeName = '/game';
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final Random _random = Random();

  // 0 = blank start (die_0.png)
  List<int> dice = List.filled(6, 0);

  // Midlertidig låste (kan toggles fritt etter kast – må utgjøre gyldig poeng)
  Set<int> locked = {};
  // Frosne (allerede lagt til rundepoeng; kastes ikke igjen; kan ikke toggles)
  Set<int> frozen = {};

  // Poeng i pågående runde
  int turnScore = 0;

  // To spillere
  int currentPlayer = 0; // 0 eller 1
  final List<int> totalScores = [0, 0];
  final List<bool> hasOpened = [false, false];

  // Regler (fra GameSetup)
  bool ruleMustOpen1000 = true;
  bool ruleMinBank300 = true;
  bool ruleNoBankBetween9000And10000 = true;

  bool get isFirstRoll => dice.contains(0);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map) {
      final rules = args['rules'] as Map?;
      if (rules != null) {
        ruleMustOpen1000 = rules['mustOpenWith1000'] ?? ruleMustOpen1000;
        ruleMinBank300 = rules['minBank300'] ?? ruleMinBank300;
        ruleNoBankBetween9000And10000 =
            rules['noBankBetween9000And10000'] ?? ruleNoBankBetween9000And10000;
      }
    }
  }

  // ---------- SCORING ----------

  int _scoreCounts(Map<int, int> counts, int used) {
    // Straight 1–6: alle seks og hver 1..6 én gang
    final isStraight = used == 6 &&
        counts.length == 6 &&
        [1, 2, 3, 4, 5, 6].every((v) => (counts[v] ?? 0) == 1);
    if (isStraight) return 2000;

    // Tre par: seks terninger, tre verdier med count == 2
    final isThreePairs =
        used == 6 && counts.values.where((c) => c == 2).length == 3;
    if (isThreePairs) return 1500;

    int total = 0;

    for (int value = 1; value <= 6; value++) {
      final count = counts[value] ?? 0;
      if (count == 0) continue;

      if (count >= 3) {
        final base = (value == 1) ? 1000 : value * 100;
        final mult = (count == 3)
            ? 1
            : (count == 4)
            ? 2
            : (count == 5)
            ? 3
            : 4; // 6 like = 4x tre-like
        total += base * mult;

        // Ekstra 1/5 utover tre-like gir enkeltscore
        final remainder = count - 3;
        if (value == 1 && remainder > 0) total += remainder * 100;
        if (value == 5 && remainder > 0) total += remainder * 50;
      } else {
        if (value == 1) total += count * 100;
        if (value == 5) total += count * 50;
      }
    }

    return total;
  }

  int _scoreForIndices(Set<int> idxs) {
    if (idxs.isEmpty) return 0;
    final counts = <int, int>{};
    for (final i in idxs) {
      final v = dice[i];
      if (v == 0) return 0; // blank gir ikke poeng
      counts[v] = (counts[v] ?? 0) + 1;
    }
    return _scoreCounts(counts, idxs.length);
  }

  int get lockedScore => _scoreForIndices(locked);
  bool _lockedIsValidScoringSubset() {
    if (locked.isEmpty) return false;

    final counts = <int, int>{};
    for (final i in locked) {
      final v = dice[i];
      if (v == 0) return false;
      counts[v] = (counts[v] ?? 0) + 1;
    }

    // Straight/tre par krever alle seks
    final isStraight = locked.length == 6 &&
        counts.length == 6 &&
        [1, 2, 3, 4, 5, 6].every((v) => (counts[v] ?? 0) == 1);
    final isThreePairs =
        locked.length == 6 && counts.values.where((c) => c == 2).length == 3;
    if (isStraight || isThreePairs) return true;

    // Ellers: ingen “døde” (2/3/4/6 må være >=3 når de låses)
    for (int value = 2; value <= 6; value++) {
      if (value == 5) continue;
      final c = counts[value] ?? 0;
      if (c > 0 && value != 1 && value != 5 && c < 3) return false;
    }

    return _scoreCounts(counts, locked.length) > 0;
  }

  bool get allSixFrozen => frozen.length == 6;

  // ---------- STATE HELPERS ----------

  // Første kast: alltid lov. Etterpå: lov hvis locked er gyldig poengkombinasjon.
  bool get canRoll => isFirstRoll || _lockedIsValidScoringSubset();

  // Bank: locked må være gyldig og bank-regler oppfylt
  bool get canBank {
    if (!_lockedIsValidScoringSubset()) return false;
    final addNow = lockedScore;
    final candidateTurnAdd = turnScore + addNow;

    // Åpning ≥ 1000
    if (!hasOpened[currentPlayer] && ruleMustOpen1000) {
      if (candidateTurnAdd < 1000) return false;
    }
    // Min. 300 etter åpning
    if (hasOpened[currentPlayer] && ruleMinBank300) {
      if (candidateTurnAdd < 300) return false;
    }

    // Ikke bank mellom 9000 og 10000
    final projectedTotal = totalScores[currentPlayer] + candidateTurnAdd;
    if (ruleNoBankBetween9000And10000) {
      if (projectedTotal > 9000 && projectedTotal < 10000) return false;
    }
    return true;
  }

  // ---------- ACTIONS ----------

  void _firstRoll() {
    setState(() {
      dice = List.generate(6, (_) => _random.nextInt(6) + 1);
    });
  }

  void _rollDice() {
    if (!canRoll) return;

    setState(() {
      // 1) Legg poeng fra locked til turnScore, og flytt dem til frozen.
      final add = lockedScore;
      turnScore += add;
      frozen.addAll(locked);
      locked.clear();

      // 2) Hot dice? (alle 6 frosne) → frigjør og kast alle 6 på nytt.
      if (allSixFrozen) {
        frozen.clear();
        dice = List.generate(6, (_) => _random.nextInt(6) + 1);
      } else {
        // 3) Kast bare de som ikke er frosne
        dice = List.generate(6, (i) {
          if (frozen.contains(i)) return dice[i]; // behold frosne
          return _random.nextInt(6) + 1;
        });
      }
    });
  }

  void _toggleLock(int index) {
    // Første klikk før første kast → gjør første kast
    if (dice[index] == 0 && isFirstRoll) {
      _firstRoll();
      return;
    }
    // Frosne kan ikke toggles
    if (frozen.contains(index)) return;

    setState(() {
      if (locked.contains(index)) {
        locked.remove(index);
      } else {
        locked.add(index);
      }
    });
  }

  void _bank() {
    if (!canBank) return;

    final addNow = lockedScore;
    final addTotal = turnScore + addNow;
    final nextTotal = totalScores[currentPlayer] + addTotal;

    setState(() {
      totalScores[currentPlayer] = nextTotal;
      if (!hasOpened[currentPlayer] && addTotal >= 1000) {
        hasOpened[currentPlayer] = true;
      }
    });

    // Vinner-sjekk (>= 10000)
    if (nextTotal >= 10000) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        WinnerScreen.routeName,
            (route) => false,
        arguments: {
          'winnerPlayerIndex': currentPlayer,
          'winnerScore': nextTotal,
        },
      );
      return;
    }

    // Neste spiller: reset runde
    setState(() {
      currentPlayer = currentPlayer == 0 ? 1 : 0;
      turnScore = 0;
      dice = List.filled(6, 0);
      locked.clear();
      frozen.clear();
    });
  }

  void _pass() {
    // Gi turen videre uten poeng
    setState(() {
      currentPlayer = currentPlayer == 0 ? 1 : 0;
      turnScore = 0;
      dice = List.filled(6, 0);
      locked.clear();
      frozen.clear();
    });
  }

  // ---------- UI ----------

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context)!;

    // Hjelpetekst (vis ikke før første kast)
    String? helper;
    if (!isFirstRoll) {
      if (!canRoll) {
        helper =
            l.helperLockValidCombo; // “Lås en gyldig poengkombinasjon …”
      } else if (!canBank) {
        final candidate = turnScore + lockedScore;
        if (!hasOpened[currentPlayer] && ruleMustOpen1000 && candidate < 1000) {
          helper = l.helperMustOpen1000;
        } else if (hasOpened[currentPlayer] &&
            ruleMinBank300 &&
            candidate < 300) {
          helper = l.helperMinBank300;
        } else {
          // kan være sperret av 9000–10000-regelen
          final projected = totalScores[currentPlayer] + candidate;
          if (ruleNoBankBetween9000And10000 &&
              projected > 9000 &&
              projected < 10000) {
            helper = l.helperNoBankBetween;
          }
        }
      }
    }

    final lockedPts = lockedScore;

    return Scaffold(
      appBar: AppBar(
        title: Text(l.score),
        backgroundColor: theme.colorScheme.surface,
      ),
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Toppinfo
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("${l.currentPlayer}: ${currentPlayer + 1}",
                      style: theme.textTheme.titleLarge),
                  Text("${l.turnScore}: $turnScore",
                      style: theme.textTheme.titleMedium),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("${l.player} 1: ${totalScores[0]}",
                      style: theme.textTheme.bodyLarge),
                  Text("${l.player} 2: ${totalScores[1]}",
                      style: theme.textTheme.bodyLarge),
                ],
              ),
              const SizedBox(height: 8),
              Text("${l.lockedScore}: $lockedPts",
                  style: theme.textTheme.bodyMedium),
              const SizedBox(height: 12),

              // Grid med 6 terninger
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                ),
                itemCount: dice.length,
                itemBuilder: (context, index) {
                  final value = dice[index];
                  final isLocked = locked.contains(index);
                  final isFrozen = frozen.contains(index);

                  Color borderColor = Colors.transparent;
                  if (isFrozen) {
                    borderColor = Colors.green; // frosne = banket i runden
                  } else if (isLocked) {
                    borderColor = Colors.orange; // valgt nå
                  }

                  return GestureDetector(
                    onTap: () => _toggleLock(index),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: borderColor, width: 4),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Image.asset(
                        'assets/dice/standard/die_$value.png',
                        height: 64,
                        width: 64,
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 12),
              if (helper != null)
                Text(
                  helper,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium,
                ),

              const Spacer(),
              // Løft knappene litt opp
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: canRoll ? _rollDice : null,
                      child: Text(l.roll),
                    ),
                    ElevatedButton(
                      onPressed: canBank ? _bank : null,
                      child: Text(l.bank),
                    ),
                    OutlinedButton(
                      onPressed: _pass,
                      child: Text(l.pass),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
