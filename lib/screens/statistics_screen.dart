import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class StatisticsScreen extends StatelessWidget {
  static const routeName = '/statistics';

  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.statistics),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Text(
            // TODO: Koble til ekte statistikk senere
            "Your game statistics will be displayed here.",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ),
    );
  }
}
