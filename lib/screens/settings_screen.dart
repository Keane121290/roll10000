import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text(localizations.settings),
        backgroundColor: theme.colorScheme.surface,
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text(localizations.language),
            subtitle: Text(localizations.languageHint),
            leading: const Icon(Icons.language),
            onTap: () {
              Navigator.pushNamed(context, '/language');
            },
          ),
          ListTile(
            title: Text(localizations.theme),
            leading: const Icon(Icons.brightness_6),
            onTap: () {
              Navigator.pushNamed(context, '/theme');
            },
          ),
        ],
      ),
    );
  }
}
