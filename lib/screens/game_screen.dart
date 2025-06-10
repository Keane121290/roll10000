import 'package:flutter/material.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  bool vsCpu = true;
  String difficulty = 'Easy';
  Map<String, bool> rules = {
    'confirmCombinations': true,
    'minBank300': true,
    'mustOpenWith1000': true,
    'noBankBetween9000And10000': true,
  };

  int currentPlayer = 1;
  int currentRoundPoints = 0;
  List<int> diceValues = List.filled(6, 1);
  List<bool> diceLocked = List.filled(6, false);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map) {
      vsCpu = args['vsCpu'] ?? true;
      difficulty = args['difficulty'] ?? 'Easy';
      rules = Map<String, bool>.from(args['rules'] ?? {});
    }
  }

  void _rollDice() {
    setState(() {
      for (int i = 0; i < diceValues.length; i++) {
        if (!diceLocked[i]) {
          diceValues[i] = 1 + (DateTime.now().millisecondsSinceEpoch + i) % 6;
        }
      }
    });
  }

  void _toggleDieLock(int index) {
    setState(() {
      diceLocked[index] = !diceLocked[index];
    });
  }

  void _lockAllDice() {
    setState(() {
      diceLocked = List.filled(6, true);
    });
  }

  void _bankPoints() {
    setState(() {
      currentRoundPoints = 0;
      currentPlayer = currentPlayer == 1 ? 2 : 1;
      diceLocked = List.filled(6, false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final playerLabel = vsCpu
        ? (currentPlayer == 1 ? 'You' : 'Computer')
        : (currentPlayer == 1 ? 'Player 1' : 'Player 2');

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              // Back button
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pushNamedAndRemoveUntil(
                      context, '/home', (route) => false),
                ),
              ),

              // Player scores
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildScoreBox('Player 1', currentPlayer == 1, theme),
                  _buildScoreBox(
                      vsCpu ? 'Computer' : 'Player 2', currentPlayer == 2, theme),
                ],
              ),

              const SizedBox(height: 16),

              // Round score
              Text(
                '(${currentRoundPoints.toString()})',
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: Colors.greenAccent.shade400,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              // Lock all button
              Center(
                child: ElevatedButton(
                  onPressed: _lockAllDice,
                  child: const Text('Lock all'),
                ),
              ),

              const SizedBox(height: 24),

              // Dice rows (2 x 3)
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (index) => _buildDie(index)),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (index) => _buildDie(index + 3)),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Roll & Bank buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _rollDice,
                    child: const Text('Roll'),
                  ),
                  ElevatedButton(
                    onPressed: _bankPoints,
                    child: const Text('Bank'),
                  ),
                ],
              ),

              const Spacer(),

              // Banner ad space
              Container(
                height: 56,
                width: double.infinity,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text('Ad banner placeholder'),
              ),

              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScoreBox(String label, bool isActive, ThemeData theme) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: isActive
              ? theme.colorScheme.primaryContainer
              : theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: theme.textTheme.labelLarge,
            ),
            const SizedBox(height: 4),
            const Text(
              '0', // Placeholder for total score
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDie(int index) {
    final theme = Theme.of(context);
    final isLocked = diceLocked[index];
    return GestureDetector(
      onTap: () => _toggleDieLock(index),
      child: Container(
        width: 70,
        height: 70,
        margin: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: isLocked
              ? theme.colorScheme.primaryContainer
              : theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isLocked ? theme.colorScheme.primary : Colors.transparent,
            width: 2,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          diceValues[index].toString(),
          style: theme.textTheme.headlineSmall?.copyWith(fontSize: 28),
        ),
      ),
    );
  }
}
