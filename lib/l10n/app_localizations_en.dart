// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Roll 10000';

  @override
  String get homeTitle => 'Roll 10000';

  @override
  String get newGame => 'New Game';

  @override
  String get continueGame => 'Continue';

  @override
  String get rulesTutorial => 'Rules';

  @override
  String get statistics => 'Statistics';

  @override
  String get gameSetup => 'Game Setup';

  @override
  String get chooseMode => 'Choose Mode';

  @override
  String get twoPlayer => 'Two Players';

  @override
  String get vsCpu => 'Vs Computer';

  @override
  String get difficulty => 'Difficulty';

  @override
  String get easy => 'Easy';

  @override
  String get medium => 'Medium';

  @override
  String get hard => 'Hard';

  @override
  String get rules => 'Rules';

  @override
  String get confirmCombinations => 'Confirm combinations';

  @override
  String get minBank300 => 'Minimum bank 300 points';

  @override
  String get mustOpen1000 => 'Must open with 1000 points';

  @override
  String get noBankBetween9000And10000 => 'No banking between 9000 and 10000';

  @override
  String get startGame => 'Start Game';

  @override
  String get rulesGoal => 'Reach 10000 points to win.';

  @override
  String get rulesHowToPlay => 'Roll dice, keep scoring ones and fives, or combos.';

  @override
  String get rulesScoring => '1 = 100 points, 5 = 50 points, triple = value*100.';

  @override
  String get rulesOther => 'If no scoring dice, your turn ends.';

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
  String get player1 => 'Player 1';

  @override
  String get player2 => 'Player 2';

  @override
  String get turnScore => 'Turn score';

  @override
  String get roll => 'Roll';

  @override
  String get bank => 'Bank';

  @override
  String get noScoreMessage => 'No scoring dice! Turn lost.';

  @override
  String get winnerTitle => 'Winner';

  @override
  String winnerCongrats(Object player) {
    return '🎉 Congratulations Player $player!';
  }

  @override
  String winnerScoreLine(Object score) {
    return 'Final score: $score';
  }

  @override
  String get playAgain => 'Play Again';

  @override
  String get backToHome => 'Back to Home';

  @override
  String get ok => 'OK';

  @override
  String get gameTitle => '10000';
}
