import 'package:flutter/material.dart';
import 'screens/splash.dart';

void main() {
  runApp(const MinhaGaleriaApp());
}

class MinhaGaleriaApp extends StatelessWidget {
  const MinhaGaleriaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My gallery',
      theme: ThemeData(
        fontFamily: 'Arial',
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.grey,
        ),
        useMaterial3: false,
      ),
      home: const SplashScreen(),
    );
  }
}
