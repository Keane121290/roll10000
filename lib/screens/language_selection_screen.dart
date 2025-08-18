import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../state/app_state.dart';

class LanguageSelectionScreen extends StatelessWidget {
  static const routeName = '/language';

  const LanguageSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.language),
      ),
      body: ListView(
        children: [
          RadioListTile<Locale>(
            title: const Text("English"),
            value: const Locale('en'),
            groupValue: appState.locale,
            onChanged: (value) {
              if (value != null) {
                context.read<AppState>().setLocale(value);
              }
            },
          ),
          RadioListTile<Locale>(
            title: const Text("Norsk"),
            value: const Locale('nb'),
            groupValue: appState.locale,
            onChanged: (value) {
              if (value != null) {
                context.read<AppState>().setLocale(value);
              }
            },
          ),
        ],
      ),
    );
  }
}
