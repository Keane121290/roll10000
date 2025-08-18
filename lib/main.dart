import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'l10n/app_localizations.dart';
import 'routes/route_generator.dart';
import 'state/app_state.dart';
import 'theme/app_theme.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appState = AppState();
  await appState.loadPreferences(); // 👈 Laster lagrede valg før appen starter

  runApp(
    ChangeNotifierProvider(
      create: (_) => appState,
      child: const Roll10000App(),
    ),
  );
}

class Roll10000App extends StatelessWidget {
  const Roll10000App({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        return MaterialApp(
          title: 'Roll10000',
          theme: appState.isDarkMode
              ? AppTheme.darkTheme
              : AppTheme.lightTheme,
          debugShowCheckedModeBanner: false,
          initialRoute: SplashScreen.routeName, // 👈 Starter alltid på splash
          onGenerateRoute: RouteGenerator.generateRoute,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'),
            Locale('nb'),
          ],
          locale: appState.locale,
        );
      },
    );
  }
}
