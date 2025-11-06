import 'package:flutter/material.dart';
import 'welcome_screen.dart';

void main() {
  runApp(const DelivApp());
}

class DelivApp extends StatelessWidget {
  const DelivApp({super.key});

  // Color “semilla” para generar la paleta (similar al botón rosado de tu mock)
  static const seed = Color(0xFFD6ADA7); // puedes ajustar este hex

  @override
  Widget build(BuildContext context) {
    final lightScheme = ColorScheme.fromSeed(
      seedColor: seed,
      brightness: Brightness.light,
    );
    final darkScheme = ColorScheme.fromSeed(
      seedColor: seed,
      brightness: Brightness.dark,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Deliv',
      themeMode: ThemeMode.system, // usa claro u oscuro según el sistema
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: lightScheme,
        textTheme: const TextTheme(
          headlineMedium: TextStyle(fontWeight: FontWeight.w800),
          bodyMedium: TextStyle(color: Colors.black54),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: darkScheme,
        textTheme: const TextTheme(
          headlineMedium: TextStyle(fontWeight: FontWeight.w800),
          bodyMedium: TextStyle(), // toma el color por defecto del tema oscuro
        ),
      ),
      home: const WelcomeScreen(),
    );
  }
}
