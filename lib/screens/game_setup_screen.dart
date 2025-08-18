import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../l10n/app_localizations.dart';

class GameSetupScreen extends StatefulWidget {
  static const routeName = '/game-setup';
  const GameSetupScreen({super.key});

  @override
  State<GameSetupScreen> createState() => _GameSetupScreenState();
}

class _GameSetupScreenState extends State<GameSetupScreen> {
  bool playAgainstCpu = true;
  String difficulty = 'Easy';

  bool confirmCombinations = true;
  bool minBank300 = true;
  bool mustOpenWith1000 = true;
  bool noBankBetween9000And10000 = true;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      playAgainstCpu = prefs.getBool('playAgainstCpu') ?? true;
      difficulty = prefs.getString('difficulty') ?? 'Easy';
      confirmCombinations = prefs.getBool('confirmCombinations') ?? true;
      minBank300 = prefs.getBool('minBank300') ?? true;
      mustOpenWith1000 = prefs.getBool('mustOpenWith1000') ?? true;
      noBankBetween9000And10000 =
          prefs.getBool('noBankBetween9000And10000') ?? true;
    });
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('playAgainstCpu', playAgainstCpu);
    await prefs.setString('difficulty', difficulty);
    await prefs.setBool('confirmCombinations', confirmCombinations);
    await prefs.setBool('minBank300', minBank300);
    await prefs.setBool('mustOpenWith1000', mustOpenWith1000);
    await prefs.setBool('noBankBetween9000And10000', noBankBetween9000And10000);
  }

  void _startGame() async {
    await _savePreferences();
    Navigator.pushNamed(
      context,
      '/game',
      arguments: {
        'vsCpu': playAgainstCpu,
        'difficulty': difficulty,
        'rules': {
          'confirmCombinations': confirmCombinations,
          'minBank300': minBank300,
          'mustOpenWith1000': mustOpenWith1000,
          'noBankBetween9000And10000': noBankBetween9000And10000,
        },
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.gameSetup),
        backgroundColor: theme.colorScheme.surface,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ListView(
          children: [
            Text(
              localizations.chooseMode,
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            RadioListTile<bool>(
              value: false,
              groupValue: playAgainstCpu,
              onChanged: (value) => setState(() => playAgainstCpu = value!),
              title: Text(localizations.twoPlayer),
            ),
            RadioListTile<bool>(
              value: true,
              groupValue: playAgainstCpu,
              onChanged: (value) => setState(() => playAgainstCpu = value!),
              title: Text(localizations.vsComputer),
            ),
            if (playAgainstCpu) ...[
              const SizedBox(height: 16),
              Text(
                localizations.difficulty,
                style: theme.textTheme.titleMedium,
              ),
              DropdownButton<String>(
                value: difficulty,
                onChanged: (value) => setState(() => difficulty = value!),
                items: [
                  DropdownMenuItem(
                      value: 'Easy', child: Text(localizations.difficultyEasy)),
                  DropdownMenuItem(
                      value: 'Medium',
                      child: Text(localizations.difficultyMedium)),
                  DropdownMenuItem(
                      value: 'Hard', child: Text(localizations.difficultyHard)),
                ],
              ),
            ],
            const Divider(height: 32),
            Text(
              localizations.rulesSection,
              style: theme.textTheme.titleLarge,
            ),
            CheckboxListTile(
              value: confirmCombinations,
              onChanged: (value) =>
                  setState(() => confirmCombinations = value!),
              title: Text(localizations.ruleConfirmCombinations),
            ),
            CheckboxListTile(
              value: minBank300,
              onChanged: (value) => setState(() => minBank300 = value!),
              title: Text(localizations.ruleMinBank300),
            ),
            CheckboxListTile(
              value: mustOpenWith1000,
              onChanged: (value) => setState(() => mustOpenWith1000 = value!),
              title: Text(localizations.ruleMustOpen1000),
            ),
            CheckboxListTile(
              value: noBankBetween9000And10000,
              onChanged: (value) =>
                  setState(() => noBankBetween9000And10000 = value!),
              title: Text(localizations.ruleNoBankBetween9000),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _startGame,
              child: Text(localizations.startGame),
            ),
          ],
        ),
      ),
    );
  }
}
