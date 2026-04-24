import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_state.dart';
import 'screens/main_layout.dart';
import 'login_screen.dart';
import 'theme/design_system.dart';

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
      home: Consumer<AppState>(
        builder: (context, appState, _) {
          if (appState.isLoading && !appState.isLoggedIn) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator(color: DesignSystem.primaryGold)),
            );
          }
          if (appState.isLoggedIn) {
            return const MainLayout();
          } else {
            return const LoginScreen();
          }
        },
      ),
    );
  }
}
