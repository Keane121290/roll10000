// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Norwegian Bokmål (`nb`).
class AppLocalizationsNb extends AppLocalizations {
  AppLocalizationsNb([String locale = 'nb']) : super(locale);

  @override
  String get appTitle => '10000 Kast';

  @override
  String get homeWelcome => 'Velkommen til 10000 Kast!';

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
}
