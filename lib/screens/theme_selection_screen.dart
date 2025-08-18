import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../state/app_state.dart';

class ThemeSelectionScreen extends StatelessWidget {
  static const routeName = '/theme';

  const ThemeSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.theme),
      ),
      body: ListView(
        children: [
          RadioListTile<bool>(
            title: Text(localizations.lightTheme),
            value: false,
            groupValue: appState.isDarkMode,
            onChanged: (value) {
              if (value != null) {
                context.read<AppState>().setThemeMode(value);
              }
            },
          ),
          RadioListTile<bool>(
            title: Text(localizations.darkTheme),
            value: true,
            groupValue: appState.isDarkMode,
            onChanged: (value) {
              if (value != null) {
                context.read<AppState>().setThemeMode(value);
              }
            },
          ),
        ],
      ),
    );
  }
}
