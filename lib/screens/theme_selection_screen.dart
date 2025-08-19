import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // hvis du bruker provider
import '../state/app_state.dart';
import '../l10n/app_localizations.dart';

class ThemeSelectionScreen extends StatelessWidget {
  static const routeName = '/theme-selection';
  const ThemeSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final appState = context.watch<AppState>(); // henter nåværende themeMode

    return Scaffold(
      appBar: AppBar(title: Text(l.theme)),
      body: ListView(
        children: [
          RadioListTile<ThemeMode>(
            value: ThemeMode.dark,
            groupValue: appState.themeMode,
            onChanged: (m) => context.read<AppState>().setThemeMode(m!),
            title: Text(l.darkTheme),
          ),
          RadioListTile<ThemeMode>(
            value: ThemeMode.light,
            groupValue: appState.themeMode,
            onChanged: (m) => context.read<AppState>().setThemeMode(m!),
            title: Text(l.lightTheme),
          ),
        ],
      ),
    );
  }
}
