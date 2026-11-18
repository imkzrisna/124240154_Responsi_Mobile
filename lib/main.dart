import 'package:flutter/material.dart';

import 'database/hive_service.dart';
import 'screens/main_screen.dart';
import 'screens/login_screen.dart';
import 'services/pref_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Hive: init, daftarkan adapter, dan buka box sebelum runApp.
  await HiveService.init();

  final isLoggedIn = await PrefService().isLoggedIn();

  runApp(HydraGamesApp(isLoggedIn: isLoggedIn));
}

class HydraGamesApp extends StatelessWidget {
  final bool isLoggedIn;

  const HydraGamesApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hydra Games',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        colorScheme: const ColorScheme.dark(primary: Colors.blue),
        useMaterial3: true,
      ),
      home: isLoggedIn ? const MainScreen() : const LoginScreen(),
    );
  }
}
