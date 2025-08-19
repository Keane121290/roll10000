import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:roll10000/l10n/app_localizations.dart';
import 'package:roll10000/screens/winner_screen.dart';

class GameScreen extends StatefulWidget {
  static const routeName = '/game';

  final bool vsComputer;

  const GameScreen({super.key, required this.vsComputer});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final Random _random = Random();

  // Start med 6 enere på brettet
  List<int> dice = [1, 1, 1, 1, 1, 1];
  List<bool> locked = [false, false, false, false, false, false];

  int currentPlayer = 0; // 0 = Player 1, 1 = Player 2/CPU
  List<int> bankedScores = [0, 0];

  int turnScore = 0;
  bool rolling = false;
  bool showNoScoreMessage = false;

  // --- Kast / animasjon ---
  Future<void> _rollDice() async {
    if (rolling) return;

    setState(() {
      rolling = true;
      showNoScoreMessage = false;
    });

    // Liten "kast"-animasjon for de terningene som IKKE er låst
    for (int t = 0; t < 10; t++) {
      await Future.delayed(const Duration(milliseconds: 50));
      setState(() {
        for (int i = 0; i < 6; i++) {
          if (!locked[i]) {
            dice[i] = _random.nextInt(6) + 1;
          }
        }
      });
    }

    setState(() {
      rolling = false;
    });

    // Hvis kastet ikke inneholder noen poenggivende terninger (1 eller 5),
    // vis melding og bytt tur etter 2 sekunder
    if (!_hasScoringDice()) {
      _handleNoScore();
    }
  }

  // --- Låsing / poeng ---
  void _toggleLock(int index) {
    if (rolling) return;

    setState(() {
      locked[index] = !locked[index];
    });
    _updateTurnScore();
  }

  void _updateTurnScore() {
    int score = 0;
    for (int i = 0; i < 6; i++) {
      if (locked[i]) {
        score += _scoreForDie(dice[i]);
      }
    }
    setState(() {
      turnScore = score;
    });
  }

  int _scoreForDie(int die) {
    if (die == 1) return 100;
    if (die == 5) return 50;
    return 0;
  }

  bool _hasScoringDice() {
    for (int i = 0; i < 6; i++) {
      if (!locked[i] && _scoreForDie(dice[i]) > 0) {
        return true;
      }
    }
    return false;
  }

  // --- Bank / turbytte / vinner ---
  void _bankScore() {
    if (turnScore == 0) return;

    setState(() {
      bankedScores[currentPlayer] += turnScore;
      turnScore = 0;
      locked = [false, false, false, false, false, false];
    });

    if (bankedScores[currentPlayer] >= 10000) {
      // Bruk pushNamed + Map arguments (ikke WinnerScreenArgs)
      Navigator.pushNamed(
        context,
        WinnerScreen.routeName,
        arguments: {
          'winnerPlayerIndex': currentPlayer,
          'winnerScore': bankedScores[currentPlayer],
        },
      );
      return;
    }

    _endTurn();
  }

  void _endTurn() {
    setState(() {
      currentPlayer = (currentPlayer + 1) % 2;
      locked = [false, false, false, false, false, false];
      dice = [1, 1, 1, 1, 1, 1]; // neste spiller ser 6 enere til de kaster
      turnScore = 0;
      showNoScoreMessage = false;
    });
  }

  void _handleNoScore() {
    final l = AppLocalizations.of(context)!;

    setState(() {
      showNoScoreMessage = true;
      turnScore = 0;
      locked = [false, false, false, false, false, false];
    });

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l.noScoreMessage),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      _endTurn();
    });
  }

  // --- UI ---
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l.gameTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Spillere og bankede poeng (markér aktiv spiller)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildPlayerBox(l.player1, bankedScores[0], currentPlayer == 0),
              _buildPlayerBox(
                widget.vsComputer ? "CPU" : l.player2,
                bankedScores[1],
                currentPlayer == 1,
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Terninger (fast 3 + 3 layout)
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (i) => _buildDie(i)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (i) => _buildDie(i + 3)),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Turn score
          Text(
            "(${l.turnScore}: $turnScore)",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 20),

          // Roll + Bank
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                // Om du vil: krev at minst én poenggivende terning er låst før ny kast
                onPressed: rolling ? null : _rollDice,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(120, 50),
                ),
                child: Text(l.roll),
              ),
              ElevatedButton(
                onPressed: turnScore > 0 ? _bankScore : null,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(120, 50),
                ),
                child: Text(l.bank),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // "No score"-melding (bruk ARB-nøkkelen noScoreMessage)
          if (showNoScoreMessage)
            Text(
              l.noScoreMessage,
              style: const TextStyle(color: Colors.red, fontSize: 18),
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }

  Widget _buildPlayerBox(String name, int score, bool isActive) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isActive ? Colors.green[300] : Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(name, style: const TextStyle(fontSize: 18)),
          Text("$score", style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildDie(int index) {
    return GestureDetector(
      onTap: () => _toggleLock(index),
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Opacity(
          opacity: locked[index] ? 0.5 : 1.0,
          child: Image.asset(
            'assets/dice/standard/die_${dice[index]}.png',
            width: 60,
            height: 60,
          ),
        ),
      ),
    );
  }
}
