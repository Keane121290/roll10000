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
  final Random _random = Random();
  List<int> dice = List.filled(6, 0); // start med "blanke" terninger (die_0.png)
  int score = 0;
  int currentPlayer = 1;

  void _rollDice() {
    setState(() {
      // Lager 6 tilfeldige terningkast mellom 1 og 6
      dice = List.generate(6, (_) => _random.nextInt(6) + 1);
      // TODO: poengberegning implementeres senere
    });
  }

  void _endTurn() {
    setState(() {
      currentPlayer = currentPlayer == 1 ? 2 : 1;
      score = 0;
      dice = List.filled(6, 0); // reset til blanke terninger
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.score),
        backgroundColor: theme.colorScheme.surface,
      ),
      backgroundColor: theme.colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "${localizations.currentPlayer}: $currentPlayer",
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Text(
              "${localizations.score}: $score",
              style: theme.textTheme.headlineMedium,
            ),
            const SizedBox(height: 24),

            // 🎲 Viser 6 terninger fra assets
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
                return Image.asset(
                  'assets/dice/standard/die_$value.png',
                  height: 64,
                  width: 64,
                );
              },
            ),

            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _rollDice,
                  child: Text(localizations.roll),
                ),
                ElevatedButton(
                  onPressed: _endTurn,
                  child: Text(localizations.endTurn),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
