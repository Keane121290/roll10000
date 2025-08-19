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

  // Start med seks enere (kun visuelt før første kast)
  List<int> dice = List.filled(6, 1);

  // Midlertidig låste terninger (må utgjøre gyldig poeng for Roll/Bank)
  Set<int> locked = {};
  // Frosne terninger (allerede lagt til rundepoeng; kastes ikke igjen)
  Set<int> frozen = {};

  // Poeng i pågående runde (akkumuleres hver gang du trykker Roll)
  int turnScore = 0;

  // To spillere
  int currentPlayer = 0; // 0 eller 1
  final List<int> totalScores = [0, 0];
  final List<bool> hasOpened = [false, false];

  // Regler (fra GameSetup)
  bool ruleMustOpen1000 = true;
  bool ruleMinBank300 = true;
  bool ruleNoBankBetween9000And10000 = true;
  bool vsCpu = false;
  String difficulty = 'Easy';

  // Første kastet er ikke gjort før spilleren trykker Roll
  bool hasRolled = false;

  bool get allSixFrozen => frozen.length == 6;
  bool _awaitingAutoPass = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map) {
      vsCpu = args['vsCpu'] ?? vsCpu;
      difficulty = args['difficulty'] ?? difficulty;

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
    // Straight 1–6
    final isStraight = used == 6 &&
        counts.length == 6 &&
        [1, 2, 3, 4, 5, 6].every((v) => (counts[v] ?? 0) == 1);
    if (isStraight) return 2000;

    // Tre par
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
      counts[v] = (counts[v] ?? 0) + 1;
    }

    // Straight/tre par krever alle seks
    final isStraight = locked.length == 6 &&
        counts.length == 6 &&
        [1, 2, 3, 4, 5, 6].every((v) => (counts[v] ?? 0) == 1);
    final isThreePairs =
        locked.length == 6 && counts.values.where((c) => c == 2).length == 3;
    if (isStraight || isThreePairs) return true;

    // Ellers: ingen “døde” (2/3/4/6 må være >=3 hvis de låses)
    for (int value = 2; value <= 6; value++) {
      if (value == 5) continue;
      final c = counts[value] ?? 0;
      if (c > 0 && value != 1 && value != 5 && c < 3) return false;
    }
    return _scoreCounts(counts, locked.length) > 0;
  }

  // Finnes *noen* poengkombinasjoner blant terninger som kan kastes (ikke-frosne)?
  bool _hasAnyScoringAvailable() {
    final available = <int>[];
    final counts = <int, int>{};
    for (int i = 0; i < dice.length; i++) {
      if (frozen.contains(i)) continue;
      available.add(i);
      final v = dice[i];
      counts[v] = (counts[v] ?? 0) + 1;
    }
    if (available.isEmpty) return false;

    // Straight / tre par krever 6 terninger tilgjengelig
    if (available.length == 6) {
      final isStraight = counts.length == 6 &&
          [1, 2, 3, 4, 5, 6].every((v) => (counts[v] ?? 0) == 1);
      if (isStraight) return true;

      final isThreePairs = counts.values.where((c) => c == 2).length == 3;
      if (isThreePairs) return true;
    }

    // Enkelt 1/5 eller tre-like
    if ((counts[1] ?? 0) > 0) return true;
    if ((counts[5] ?? 0) > 0) return true;
    for (int v = 2; v <= 6; v++) {
      if (v == 5) continue;
      if ((counts[v] ?? 0) >= 3) return true;
    }
    return false;
  }

  // ---------- STATE HELPERS ----------

  // Første kast: alltid lov. Etterpå: lov hvis locked er gyldig poengkombinasjon.
  bool get canRoll => !hasRolled || _lockedIsValidScoringSubset();

  // Bank er lov hvis locked er gyldig + bankeregler oppfylt
  bool get canBank {
    if (!_lockedIsValidScoringSubset()) return false;
    final addNow = lockedScore;
    final candidateTurnAdd = turnScore + addNow;

    if (!hasOpened[currentPlayer] && ruleMustOpen1000) {
      if (candidateTurnAdd < 1000) return false;
    }
    if (hasOpened[currentPlayer] && ruleMinBank300) {
      if (candidateTurnAdd < 300) return false;
    }

    final projectedTotal = totalScores[currentPlayer] + candidateTurnAdd;
    if (ruleNoBankBetween9000And10000) {
      if (projectedTotal > 9000 && projectedTotal < 10000) return false;
    }
    return true;
  }

  // ---------- ACTIONS ----------

  void _rollDice() {
    if (!canRoll || _awaitingAutoPass) return;

    setState(() {
      if (!hasRolled) {
        // Første kast: rull alle seks
        hasRolled = true;
        dice = List.generate(6, (_) => _random.nextInt(6) + 1);
        // locked/frozen er allerede tomme
      } else {
        // Legg poeng fra locked til turnScore, og frys dem
        final add = lockedScore;
        turnScore += add;
        frozen.addAll(locked);
        locked.clear();

        // Hot dice? → nullstill frosne og kast alle 6
        if (allSixFrozen) {
          frozen.clear();
          dice = List.generate(6, (_) => _random.nextInt(6) + 1);
        } else {
          // Kast bare de som ikke er frosne
          dice = List.generate(6, (i) {
            if (frozen.contains(i)) return dice[i];
            return _random.nextInt(6) + 1;
          });
        }
      }
    });

    // Etter et kast: hvis ingen poengkombinasjoner → auto-pass etter 2 sek
    if (_hasAnyScoringAvailable() == false) {
      _showFarkleAndAutoPass();
    }
  }

  void _toggleLock(int index) {
    if (_awaitingAutoPass) return;
    // Man skal ikke kunne låse før man har kastet
    if (!hasRolled) return;

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
    if (!canBank || _awaitingAutoPass) return;

    final addNow = lockedScore;
    final addTotal = turnScore + addNow;
    final nextTotal = totalScores[currentPlayer] + addTotal;

    setState(() {
      totalScores[currentPlayer] = nextTotal;
      if (!hasOpened[currentPlayer] && addTotal >= 1000) {
        hasOpened[currentPlayer] = true;
      }
    });

    // Vinner-sjekk (≥ 10000)
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

    _nextPlayerReset();
  }

  void _nextPlayerReset() {
    setState(() {
      currentPlayer = currentPlayer == 0 ? 1 : 0;
      turnScore = 0;
      // Visuelt start-bilde for neste spiller: seks enere
      dice = List.filled(6, 1);
      locked.clear();
      frozen.clear();
      hasRolled = false;
      _awaitingAutoPass = false;
    });
  }

  void _showFarkleAndAutoPass() {
    final l = AppLocalizations.of(context)!;
    _awaitingAutoPass = true;

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l.noScoreMessage),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      _nextPlayerReset();
    });
  }

  // ---------- UI ----------

  Widget _playerBox({
    required String title,
    required int score,
    required bool active,
  }) {
    final theme = Theme.of(context);
    return Card(
      elevation: active ? 4 : 1,
      color: theme.colorScheme.surfaceVariant.withOpacity(active ? 0.95 : 0.75),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, style: theme.textTheme.titleMedium),
            const SizedBox(height: 2),
            Text(
              "$score",
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionButton(String label, {required bool enabled, required VoidCallback? onTap}) {
    final theme = Theme.of(context);
    return ElevatedButton(
      onPressed: enabled ? onTap : null,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(52),
        padding: const EdgeInsets.symmetric(vertical: 12),
        elevation: enabled ? 3 : 0,
        backgroundColor: enabled
            ? theme.colorScheme.primary
            : theme.colorScheme.surfaceVariant,
        foregroundColor: enabled
            ? theme.colorScheme.onPrimary
            : theme.colorScheme.onSurface.withOpacity(0.5),
      ),
      child: Text(
        label,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: enabled
              ? theme.colorScheme.onPrimary
              : theme.colorScheme.onSurface.withOpacity(0.5),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context)!;

    final p1Title = "${l.player} 1";
    final p2Title = vsCpu ? "Computer $difficulty" : "${l.player} 2";

    return Scaffold(
      appBar: AppBar(
        title: Text(l.score),
        backgroundColor: theme.colorScheme.surface,
      ),
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Topp: to bokser (navn + banket totalscore)
              Row(
                children: [
                  Expanded(
                    child: _playerBox(
                      title: p1Title,
                      score: totalScores[0],
                      active: currentPlayer == 0,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _playerBox(
                      title: p2Title,
                      score: totalScores[1],
                      active: currentPlayer == 1,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Terninger (3x2)
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
                    borderColor = Colors.green; // allerede i turnScore
                  } else if (isLocked) {
                    borderColor = Colors.orange; // valgt for neste roll/bank
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

              const SizedBox(height: 8),

              // Rundepoeng i parentes under terningene (i tråd med referanse)
              Center(
                child: Text(
                  "(+$turnScore)",
                  style: theme.textTheme.bodyLarge,
                ),
              ),

              const SizedBox(height: 14),

              // Roll / Bank under terningene, tydelig enabled/disabled
              Row(
                children: [
                  Expanded(
                    child: _actionButton(
                      l.roll,
                      enabled: canRoll && !_awaitingAutoPass,
                      onTap: _rollDice,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _actionButton(
                      l.bank,
                      enabled: canBank && !_awaitingAutoPass,
                      onTap: _bank,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
