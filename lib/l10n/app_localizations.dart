import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_nb.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('nb')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Roll10000'**
  String get appTitle;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageHint.
  ///
  /// In en, this message translates to:
  /// **'Tap to change language'**
  String get languageHint;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @lightTheme.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get lightTheme;

  /// No description provided for @darkTheme.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get darkTheme;

  /// No description provided for @rules.
  ///
  /// In en, this message translates to:
  /// **'Rules & Tutorial'**
  String get rules;

  /// No description provided for @statistics.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statistics;

  /// No description provided for @rulesGoal.
  ///
  /// In en, this message translates to:
  /// **'Goal:\nBe the first to score exactly 10,000 points.'**
  String get rulesGoal;

  /// No description provided for @rulesHowToPlay.
  ///
  /// In en, this message translates to:
  /// **'How to play:\n- Roll six dice.\n- Set aside at least one scoring die.\n- Re-roll the rest or end turn and bank the score.\n- If no scoring dice are rolled, turn ends with 0 points.'**
  String get rulesHowToPlay;

  /// No description provided for @rulesScoring.
  ///
  /// In en, this message translates to:
  /// **'Scoring:\n- 1s = 100 pts\n- 5s = 50 pts\n- Three 1s = 1000 pts\n- Three of a kind = 100 x number (e.g. three 4s = 400)\n- Straight (1-6) = 2000 pts\n- Three pairs = 1500 pts\n- Four/five/six of a kind = double/triple/quadruple points'**
  String get rulesScoring;

  /// No description provided for @rulesOther.
  ///
  /// In en, this message translates to:
  /// **'Other rules:\n- You must score at least 1000 in a turn to enter the game.\n- You must score at least 300 to bank points after that.'**
  String get rulesOther;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'10000 Roll'**
  String get homeTitle;

  /// No description provided for @homeNewGame.
  ///
  /// In en, this message translates to:
  /// **'New Game'**
  String get homeNewGame;

  /// No description provided for @homeContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get homeContinue;

  /// No description provided for @homeRules.
  ///
  /// In en, this message translates to:
  /// **'Rules & Tutorial'**
  String get homeRules;

  /// No description provided for @homeStatistics.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get homeStatistics;

  /// No description provided for @gameSetup.
  ///
  /// In en, this message translates to:
  /// **'Game Setup'**
  String get gameSetup;

  /// No description provided for @chooseMode.
  ///
  /// In en, this message translates to:
  /// **'Choose Mode:'**
  String get chooseMode;

  /// No description provided for @twoPlayer.
  ///
  /// In en, this message translates to:
  /// **'2 Player'**
  String get twoPlayer;

  /// No description provided for @vsComputer.
  ///
  /// In en, this message translates to:
  /// **'Player vs Computer'**
  String get vsComputer;

  /// No description provided for @difficulty.
  ///
  /// In en, this message translates to:
  /// **'Difficulty:'**
  String get difficulty;

  /// No description provided for @difficultyEasy.
  ///
  /// In en, this message translates to:
  /// **'Easy'**
  String get difficultyEasy;

  /// No description provided for @difficultyMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get difficultyMedium;

  /// No description provided for @difficultyHard.
  ///
  /// In en, this message translates to:
  /// **'Hard'**
  String get difficultyHard;

  /// No description provided for @rulesSection.
  ///
  /// In en, this message translates to:
  /// **'Rules:'**
  String get rulesSection;

  /// No description provided for @ruleConfirmCombinations.
  ///
  /// In en, this message translates to:
  /// **'Confirm combinations'**
  String get ruleConfirmCombinations;

  /// No description provided for @ruleMinBank300.
  ///
  /// In en, this message translates to:
  /// **'Min. bank 300 points'**
  String get ruleMinBank300;

  /// No description provided for @ruleMustOpen1000.
  ///
  /// In en, this message translates to:
  /// **'Must open with 1000 points'**
  String get ruleMustOpen1000;

  /// No description provided for @ruleNoBankBetween9000.
  ///
  /// In en, this message translates to:
  /// **'No banking between 9000 and 10000'**
  String get ruleNoBankBetween9000;

  /// No description provided for @startGame.
  ///
  /// In en, this message translates to:
  /// **'Start Game'**
  String get startGame;

  /// No description provided for @roll.
  ///
  /// In en, this message translates to:
  /// **'Roll'**
  String get roll;

  /// No description provided for @score.
  ///
  /// In en, this message translates to:
  /// **'Score'**
  String get score;

  /// No description provided for @nextPlayer.
  ///
  /// In en, this message translates to:
  /// **'Next Player'**
  String get nextPlayer;

  /// No description provided for @endTurn.
  ///
  /// In en, this message translates to:
  /// **'End Turn'**
  String get endTurn;

  /// No description provided for @noScoreMessage.
  ///
  /// In en, this message translates to:
  /// **'No scoring dice! Your turn ends with 0 points.'**
  String get noScoreMessage;

  /// No description provided for @bankedMessage.
  ///
  /// In en, this message translates to:
  /// **'Points banked!'**
  String get bankedMessage;

  /// No description provided for @currentPlayer.
  ///
  /// In en, this message translates to:
  /// **'Current Player'**
  String get currentPlayer;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'nb'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'nb': return AppLocalizationsNb();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
