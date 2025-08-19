import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import 'home_screen.dart';
import 'game_setup_screen.dart';

class WinnerScreen extends StatelessWidget {
  static const routeName = '/winner';

  final int winnerPlayerIndex; // 0 -> Spiller 1, 1 -> Spiller 2
  final int winnerScore;

  const WinnerScreen({
    super.key,
    required this.winnerPlayerIndex,
    required this.winnerScore,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final playerNumber = winnerPlayerIndex + 1;

    return Scaffold(
      appBar: AppBar(title: Text(l.winnerTitle)),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              l.winnerCongrats(playerNumber),
              style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              l.winnerScoreLine(winnerScore),
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  GameSetupScreen.routeName,
                      (route) => false,
                );
              },
              child: Text(l.playAgain),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  HomeScreen.routeName,
                      (route) => false,
                );
              },
              child: Text(l.backToHome),
            ),
          ],
        ),
      ),
    );
  }
}
