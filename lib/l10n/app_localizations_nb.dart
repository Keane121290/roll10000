// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Norwegian Bokmål (`nb`).
class AppLocalizationsNb extends AppLocalizations {
  AppLocalizationsNb([String locale = 'nb']) : super(locale);

  @override
  String get appTitle => '10000 Roll';

  @override
  String get homeTitle => '10000 Roll';

  @override
  String get newGame => 'Nytt spill';

  @override
  String get continueGame => 'Fortsett';

  @override
  String get rulesTutorial => 'Regler og veiledning';

  @override
  String get statistics => 'Statistikk';

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
  String get rules => 'Regler';

  @override
  String get rulesTitle => 'Regler og veiledning';

  @override
  String get rulesGoal => 'Mål:\nVær den første til å nå nøyaktig 10 000 poeng.';

  @override
  String get rulesHowToPlay => 'Slik spiller du:\n- Kast seks terninger.\n- Legg til side minst én terning som gir poeng.\n- Kast resten på nytt eller avslutt runden og bank poengene.\n- Hvis ingen terninger gir poeng, ender runden med 0 poeng.';

  @override
  String get rulesScoring => 'Poengberegning:\n- 1 = 100 poeng\n- 5 = 50 poeng\n- Tre 1’ere = 1000 poeng\n- Tre like = 100 x tallet (f.eks. tre 4’ere = 400)\n- Straight (1–6) = 2000 poeng\n- Tre par = 1500 poeng\n- Fire/fem/seks like = dobbel/trippel/firedobbel verdi';

  @override
  String get rulesOther => 'Andre regler:\n- Du må få minst 1000 poeng i en runde for å komme inn i spillet.\n- Etter det må du få minst 300 poeng for å ta vare på poeng.';

  @override
  String get gameSetup => 'Spilloppsett';

  @override
  String get chooseMode => 'Velg modus:';

  @override
  String get twoPlayer => '2 spillere';

  @override
  String get vsCpu => 'Spiller mot datamaskin';

  @override
  String get difficulty => 'Vanskelighetsgrad:';

  @override
  String get easy => 'Lett';

  @override
  String get medium => 'Middels';

  @override
  String get hard => 'Vanskelig';

  @override
  String get startGame => 'Start spill';

  @override
  String get confirmCombinations => 'Bekreft kombinasjoner';

  @override
  String get minBank300 => 'Min. bank 300 poeng';

  @override
  String get mustOpen1000 => 'Må åpne med 1000 poeng';

  @override
  String get noBankBetween9000And10000 => 'Ingen banking mellom 9000 og 10000';

  @override
  String get score => 'Poeng';

  @override
  String get turnScore => 'Rundepoeng';

  @override
  String get lockedScore => 'Låste poeng';

  @override
  String get player => 'Spiller';

  @override
  String get currentPlayer => 'Nåværende spiller';

  @override
  String get roll => 'Kast';

  @override
  String get bank => 'Bank';

  @override
  String get pass => 'Stå over';

  @override
  String get helperLockValidCombo => 'Lås en gyldig poengkombinasjon (1/5, tre like, straight eller tre par) for å kaste på nytt.';

  @override
  String get helperMustOpen1000 => 'Du må åpne med minst 1000 poeng.';

  @override
  String get helperMinBank300 => 'Du må banke minst 300 poeng.';

  @override
  String get helperNoBankBetween => 'Du kan ikke banke når totalsummen havner mellom 9000 og 10000.';

  @override
  String get winnerTitle => 'Vinner';

  @override
  String winnerCongrats(int player) {
    return 'Spiller $player vinner!';
  }

  @override
  String winnerScoreLine(int score) {
    return 'Sluttsum: $score';
  }

  @override
  String get playAgain => 'Spill igjen';

  @override
  String get backToHome => 'Til hovedmeny';
}
