// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => '10000 Roll';

  @override
  String get homeWelcome => 'Welcome to 10000 Roll!';

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
}
