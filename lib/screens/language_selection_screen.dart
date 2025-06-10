import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../state/app_state.dart';

class LanguageSelectionScreen extends StatelessWidget {
  const LanguageSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appState = Provider.of<AppState>(context);
    final currentLocale = appState.locale.languageCode;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.language),
        backgroundColor: theme.colorScheme.surface,
      ),
      backgroundColor: theme.colorScheme.surface,
      body: ListView(
        children: [
          ListTile(
            leading: const Text('🇬🇧', style: TextStyle(fontSize: 24)),
            title: const Text('English'),
            trailing: currentLocale == 'en' ? const Icon(Icons.check) : null,
            onTap: () {
              appState.setLocale(const Locale('en'));
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Text('🇳🇴', style: TextStyle(fontSize: 24)),
            title: const Text('Norsk'),
            trailing: currentLocale == 'nb' ? const Icon(Icons.check) : null,
            onTap: () {
              appState.setLocale(const Locale('nb'));
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
