import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class GameScreen extends StatefulWidget {
  static const routeName = '/game';

  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<int> dice = List.filled(6, 1); // start med 6 enere
  List<bool> locked = List.filled(6, false);

  int currentPlayer = 1;
  List<int> playerScores = [0, 0];
  int turnScore = 0;

  bool showNoScoreMessage = false;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _rollDice(firstRoll: true);
  }

  void _rollDice({bool firstRoll = false}) {
    setState(() {
      for (int i = 0; i < dice.length; i++) {
        if (!locked[i] || firstRoll) {
          dice[i] = _random.nextInt(6) + 1;
          if (firstRoll) locked[i] = false;
        }
      }

      // Sjekk om kastet i det hele tatt gir poengmulighet
      if (!_rollHasAnyScore(dice)) {
        showNoScoreMessage = true;
        Timer(const Duration(seconds: 2), () {
          _endTurn(resetTurnScore: true);
        });
      } else {
        showNoScoreMessage = false;
      }
    });
  }

  void _toggleLock(int index) {
    setState(() {
      locked[index] = !locked[index];
    });
  }

  int _calculateScore(List<int> values) {
    int score = 0;
    List<int> counts = List.filled(7, 0);
    for (var v in values) {
      counts[v]++;
    }

    // 1s og 5s
    score += counts[1] % 3 * 100;
    score += counts[5] % 3 * 50;

    // tre eller flere like
    for (int i = 1; i <= 6; i++) {
      if (counts[i] >= 3) {
        score += (i == 1 ? 1000 : i * 100) * (counts[i] - 2);
      }
    }

    // straight 1-6
    if (counts.every((c) => c == 1)) {
      score += 2000;
    }

    // tre par
    if (counts.where((c) => c == 2).length == 3) {
      score += 1500;
    }

    return score;
  }

  bool _rollHasAnyScore(List<int> values) {
    return _calculateScore(values) > 0;
  }

  void _bankScore() {
    int lockedScore = _calculateScore(
        [for (int i = 0; i < dice.length; i++) if (locked[i]) dice[i]]);
    if (lockedScore == 0) return;

    setState(() {
      turnScore += lockedScore;
      playerScores[currentPlayer - 1] += turnScore;
      turnScore = 0;
      locked = List.filled(6, false);

      if (playerScores[currentPlayer - 1] >= 10000) {
        _showWinner(currentPlayer, playerScores[currentPlayer - 1]);
      } else {
        _switchPlayer();
        _rollDice(firstRoll: true);
      }
    });
  }

  void _endTurn({bool resetTurnScore = false}) {
    setState(() {
      if (resetTurnScore) {
        turnScore = 0;
      }
      locked = List.filled(6, false);
      _switchPlayer();
      _rollDice(firstRoll: true);
    });
  }

  void _switchPlayer() {
    currentPlayer = currentPlayer == 1 ? 2 : 1;
  }

  void _showWinner(int playerNumber, int score) {
    Navigator.pushReplacementNamed(context, '/winner', arguments: {
      'player': playerNumber,
      'score': score,
    });
  }

  Widget _buildPlayerBox(String name, int score, bool isActive) {
    final theme = Theme.of(context);
    return Container(
      width: 150,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isActive
            ? theme.colorScheme.primary.withValues(alpha: 0.15)
            : theme.colorScheme.surfaceContainerHighest,
        border: Border.all(
          color: isActive ? theme.colorScheme.primary : Colors.transparent,
          width: 3,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            name,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "$score",
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(l.gameTitle),
        backgroundColor: theme.colorScheme.surface,
      ),
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildPlayerBox(l.player1, playerScores[0], currentPlayer == 1),
                _buildPlayerBox(l.player2, playerScores[1], currentPlayer == 2),
              ],
            ),
            const SizedBox(height: 20),

            // Dice grid: alltid 3 + 3
            GridView.builder(
              shrinkWrap: true,
              itemCount: dice.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => _toggleLock(index),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: locked[index]
                            ? theme.colorScheme.primary
                            : Colors.transparent,
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Image.asset(
                      'assets/dice/standard/die_${dice[index]}.png',
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 16),
            Text(
              "${l.turnScore}: $turnScore",
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 16),

            if (showNoScoreMessage)
              Text(
                l.noScoreMessage,
                style: TextStyle(color: theme.colorScheme.error, fontSize: 16),
              ),

            const Spacer(),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: locked.any((e) => e)
                      ? () => _rollDice()
                      : null, // må ha minst én låst
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                  ),
                  child: Text(l.roll),
                ),
                ElevatedButton(
                  onPressed: locked.any((e) => e) ? _bankScore : null,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                  ),
                  child: Text(l.bank),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
