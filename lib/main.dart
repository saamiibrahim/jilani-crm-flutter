import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_state.dart';
import 'screens/main_layout.dart';
import 'login_screen.dart';
import 'theme/design_system.dart';
// import 'home_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppState()..loadSavedCredentials(),
      child: const JalaniApp(),
    ),
  );
}

class JalaniApp extends StatelessWidget {
  const JalaniApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jilani Properties',
      debugShowCheckedModeBanner: false,
      theme: DesignSystem.themeData,
      builder: (context, child) {
        final mediaQuery = MediaQuery.of(context);
        final textScale = mediaQuery.textScaler.scale(1).clamp(0.9, 1.08).toDouble();
        return MediaQuery(
          data: mediaQuery.copyWith(
            textScaler: TextScaler.linear(textScale),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
      home: Consumer<AppState>(
        builder: (context, appState, _) {
          if (appState.isLoading && !appState.isLoggedIn) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(
                  color: DesignSystem.primaryContainer,
                ),
              ),
            );
          }
          if (appState.isLoggedIn) {
            return const MainLayout();
            // return const HomeScreen();
          } else {
            return const LoginScreen();
          }
        },
      ),
    );
  }
}
