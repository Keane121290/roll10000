import 'package:flutter/material.dart';
import '../screens/splash_screen.dart';
import '../screens/home_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/language_selection_screen.dart';
import '../screens/theme_selection_screen.dart'; // Denne vises ikke i UI, men kan være greit å beholde for fremtidig bruk
import '../screens/rules_screen.dart';
import '../screens/statistics_screen.dart';
import '../screens/game_setup_screen.dart';
import '../screens/game_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case '/home':
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case '/settings':
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      case '/language':
        return MaterialPageRoute(builder: (_) => const LanguageSelectionScreen());
      case '/theme':
        return MaterialPageRoute(builder: (_) => const ThemeSelectionScreen());
      case '/rules':
        return MaterialPageRoute(builder: (_) => const RulesScreen());
      case '/statistics':
        return MaterialPageRoute(builder: (_) => const StatisticsScreen());
      case '/game-setup':
        return MaterialPageRoute(builder: (_) => const GameSetupScreen());
      case '/game':
        return MaterialPageRoute(builder: (_) => const GameScreen());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
