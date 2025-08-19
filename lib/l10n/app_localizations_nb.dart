// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Norwegian Bokmål (`nb`).
class AppLocalizationsNb extends AppLocalizations {
  AppLocalizationsNb([String locale = 'nb']) : super(locale);

  @override
  String get appTitle => 'Roll 10000';

  @override
  String get homeTitle => 'Roll 10000';

  @override
  String get newGame => 'Nytt spill';

  @override
  String get continueGame => 'Fortsett';

  @override
  String get rulesTutorial => 'Regler';

  @override
  String get statistics => 'Statistikk';

  @override
  String get gameSetup => 'Spilloppsett';

  @override
  String get chooseMode => 'Velg spillmodus';

  @override
  String get twoPlayer => 'To spillere';

  @override
  String get vsCpu => 'Mot datamaskin';

  @override
  String get difficulty => 'Vanskelighetsgrad';

  @override
  String get easy => 'Lett';

  @override
  String get medium => 'Middels';

  @override
  String get hard => 'Vanskelig';

  @override
  String get rules => 'Regler';

  @override
  String get confirmCombinations => 'Bekreft kombinasjoner';

  @override
  String get minBank300 => 'Minimum bank 300 poeng';

  @override
  String get mustOpen1000 => 'Må åpne med 1000 poeng';

  @override
  String get noBankBetween9000And10000 => 'Ingen banking mellom 9000 og 10000';

  @override
  String get startGame => 'Start spill';

  @override
  String get rulesGoal => 'Førstemann til 10000 poeng vinner.';

  @override
  String get rulesHowToPlay => 'Kast terninger, behold ener og femmere, eller kombinasjoner.';

  @override
  String get rulesScoring => '1 = 100 poeng, 5 = 50 poeng, triple = verdi*100.';

  @override
  String get rulesOther => 'Hvis ingen poenggivende terninger → turen avsluttes.';

  @override
  String get settings => 'Innstillinger';

  @override
  String get language => 'Språk';

  @override
  String get languageHint => 'Trykk for å endre språk';

  @override
  String get theme => 'Tema';

  @override
  String get lightTheme => 'Lyst';

  @override
  String get darkTheme => 'Mørkt';

  @override
  String get player1 => 'Spiller 1';

  @override
  String get player2 => 'Spiller 2';

  @override
  String get turnScore => 'Rundepoeng';

  @override
  String get roll => 'Kast';

  @override
  String get bank => 'Bank';

  @override
  String get noScoreMessage => 'Ingen poenggivende terninger! Runden tapt.';

  @override
  String get winnerTitle => 'Vinner';

  @override
  String winnerCongrats(Object player) {
    return '🎉 Gratulerer Spiller $player!';
  }

  @override
  String winnerScoreLine(Object score) {
    return 'Sluttsum: $score';
  }

  @override
  String get playAgain => 'Spill igjen';

  @override
  String get backToHome => 'Tilbake til Hjem';

  @override
  String get ok => 'OK';

  @override
  String get gameTitle => '10 000';
}
