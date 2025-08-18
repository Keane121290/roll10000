import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import 'language_selection_screen.dart';
import 'theme_selection_screen.dart';

class SettingsScreen extends StatelessWidget {
  static const routeName = '/settings';

  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.settings),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text(localizations.language),
            subtitle: Text(localizations.languageHint),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.pushNamed(context, LanguageSelectionScreen.routeName);
            },
          ),
          const Divider(height: 1),
          ListTile(
            title: Text(localizations.theme),
            subtitle: Text(localizations.lightTheme + " / " + localizations.darkTheme),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.pushNamed(context, ThemeSelectionScreen.routeName);
            },
          ),
          const Divider(height: 1),
        ],
      ),
    );
  }
}
