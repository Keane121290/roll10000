import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class RulesScreen extends StatelessWidget {
  const RulesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rules & Tutorial'),
        backgroundColor: theme.colorScheme.surface,
      ),
      backgroundColor: theme.colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: const [
            Text(
              'Goal:\nBe the first to score exactly 10,000 points.',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Text(
              'How to play:\n- Roll six dice.\n- Set aside at least one scoring die.\n- Re-roll the rest or end turn and bank the score.\n- If no scoring dice are rolled, turn ends with 0 points.',
            ),
            SizedBox(height: 12),
            Text(
              'Scoring:\n- 1s = 100 pts\n- 5s = 50 pts\n- Three 1s = 1000 pts\n- Three of a kind = 100 x number (e.g. three 4s = 400)\n- Straight (1-6) = 2000 pts\n- Three pairs = 1500 pts\n- Four/five/six of a kind = double/triple/quadruple points',
            ),
            SizedBox(height: 12),
            Text('Other rules:\n- You must score at least 1000 in a turn to enter the game.\n- You must score at least 300 to bank points after that.'),
          ],
        ),
      ),
    );
  }
}
