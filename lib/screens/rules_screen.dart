import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class RulesScreen extends StatelessWidget {
  static const routeName = '/rules';

  const RulesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.rules),
        backgroundColor: theme.colorScheme.surface,
      ),
      backgroundColor: theme.colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              localizations.rulesGoal,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(localizations.rulesHowToPlay),
            const SizedBox(height: 12),
            Text(localizations.rulesScoring),
            const SizedBox(height: 12),
            Text(localizations.rulesOther),
          ],
        ),
      ),
    );
  }
}
