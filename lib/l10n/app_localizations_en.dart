// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Roll10000';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get languageHint => 'Tap to change language';

  @override
  String get theme => 'Theme';

  @override
  String get lightTheme => 'Light';

  @override
  String get darkTheme => 'Dark';

  @override
  String get rules => 'Rules & Tutorial';

  @override
  String get statistics => 'Statistics';

  @override
  String get rulesGoal => 'Goal:\nBe the first to score exactly 10,000 points.';

  @override
  String get rulesHowToPlay => 'How to play:\n- Roll six dice.\n- Set aside at least one scoring die.\n- Re-roll the rest or end turn and bank the score.\n- If no scoring dice are rolled, turn ends with 0 points.';

  @override
  String get rulesScoring => 'Scoring:\n- 1s = 100 pts\n- 5s = 50 pts\n- Three 1s = 1000 pts\n- Three of a kind = 100 x number (e.g. three 4s = 400)\n- Straight (1-6) = 2000 pts\n- Three pairs = 1500 pts\n- Four/five/six of a kind = double/triple/quadruple points';

  @override
  String get rulesOther => 'Other rules:\n- You must score at least 1000 in a turn to enter the game.\n- You must score at least 300 to bank points after that.';

  @override
  String get homeTitle => '10000 Roll';

  @override
  String get homeNewGame => 'New Game';

  @override
  String get homeContinue => 'Continue';

  @override
  String get homeRules => 'Rules & Tutorial';

  @override
  String get homeStatistics => 'Statistics';

  @override
  String get gameSetup => 'Game Setup';

  @override
  String get chooseMode => 'Choose Mode:';

  @override
  String get twoPlayer => '2 Player';

  @override
  String get vsComputer => 'Player vs Computer';

  @override
  String get difficulty => 'Difficulty:';

  @override
  String get difficultyEasy => 'Easy';

  @override
  String get difficultyMedium => 'Medium';

  @override
  String get difficultyHard => 'Hard';

  @override
  String get rulesSection => 'Rules:';

  @override
  String get ruleConfirmCombinations => 'Confirm combinations';

  @override
  String get ruleMinBank300 => 'Min. bank 300 points';

  @override
  String get ruleMustOpen1000 => 'Must open with 1000 points';

  @override
  String get ruleNoBankBetween9000 => 'No banking between 9000 and 10000';

  @override
  String get startGame => 'Start Game';

  @override
  String get roll => 'Roll';

  @override
  String get score => 'Score';

  @override
  String get nextPlayer => 'Next Player';

  @override
  String get endTurn => 'End Turn';

  @override
  String get noScoreMessage => 'No scoring dice! Your turn ends with 0 points.';

  @override
  String get bankedMessage => 'Points banked!';

  @override
  String get currentPlayer => 'Current Player';

  @override
  String get turnScore => 'Turn Score';

  @override
  String get lockedScore => 'Locked Score';

  @override
  String get player => 'Player';

  @override
  String get bank => 'Bank';

  @override
  String get pass => 'Pass';

  @override
  String get helperLockValidCombo => 'Lock a valid scoring combination (1/5, three-of-a-kind, straight, or three pairs) to roll again.';

  @override
  String get helperMustOpen1000 => 'You must open with at least 1,000 points.';

  @override
  String get helperMinBank300 => 'You must bank at least 300 points.';

  @override
  String get helperNoBankBetween => 'You cannot bank when the total would be between 9,000 and 10,000.';

  @override
  String get winnerTitle => 'Winner';

  @override
  String winnerCongrats(int player) {
    return 'Player $player wins!';
  }

  @override
  String winnerScoreLine(int score) {
    return 'Final score: $score';
  }

  @override
  String get playAgain => 'Play Again';

  @override
  String get backToHome => 'Back to Home';
}
