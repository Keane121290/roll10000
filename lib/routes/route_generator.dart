import 'package:flutter/material.dart';

import '../screens/home_screen.dart';
import '../screens/splash_screen.dart';
import '../screens/game_screen.dart';
import '../screens/game_setup_screen.dart';
import '../screens/language_selection_screen.dart';
import '../screens/rules_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/statistics_screen.dart';
import '../screens/theme_selection_screen.dart';
import '../screens/winner_screen.dart';


class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case SplashScreen.routeName:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case HomeScreen.routeName:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case GameSetupScreen.routeName:
        return MaterialPageRoute(builder: (_) => const GameSetupScreen());
      case GameScreen.routeName:
        return MaterialPageRoute(
          builder: (_) => const GameScreen(vsComputer: false), // eller dynamic
        );
      case RulesScreen.routeName:
        return MaterialPageRoute(builder: (_) => const RulesScreen());
      case SettingsScreen.routeName:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      case StatisticsScreen.routeName:
        return MaterialPageRoute(builder: (_) => const StatisticsScreen());
      case LanguageSelectionScreen.routeName:
        return MaterialPageRoute(
            builder: (_) => const LanguageSelectionScreen());
      case ThemeSelectionScreen.routeName:
        return MaterialPageRoute(builder: (_) => const ThemeSelectionScreen());
      case WinnerScreen.routeName:
        final args = settings.arguments as Map?;
        return MaterialPageRoute(
          builder: (_) => WinnerScreen(
            winnerPlayerIndex: args?['winnerPlayerIndex'] ?? 0,
            winnerScore: args?['winnerScore'] ?? 10000,
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Route not found')),
          ),
        );
    }
  }
}
