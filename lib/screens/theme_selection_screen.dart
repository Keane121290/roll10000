import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../state/app_state.dart';

class ThemeSelectionScreen extends StatelessWidget {
  const ThemeSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appState = Provider.of<AppState>(context);
    final currentTheme = appState.themeMode;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.theme),
        backgroundColor: theme.colorScheme.surface,
      ),
      backgroundColor: theme.colorScheme.surface,
      body: ListView(
        children: [
          RadioListTile<ThemeMode>(
            title: Text(AppLocalizations.of(context)!.lightTheme),
            value: ThemeMode.light,
            groupValue: currentTheme,
            onChanged: (value) {
              appState.setThemeMode(value!);
              Navigator.pop(context);
            },
          ),
          RadioListTile<ThemeMode>(
            title: Text(AppLocalizations.of(context)!.darkTheme),
            value: ThemeMode.dark,
            groupValue: currentTheme,
            onChanged: (value) {
              appState.setThemeMode(value!);
              Navigator.pop(context);
            },
          ),
          RadioListTile<ThemeMode>(
            title: const Text('System'),
            value: ThemeMode.system,
            groupValue: currentTheme,
            onChanged: (value) {
              appState.setThemeMode(value!);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
