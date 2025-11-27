import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/routing/router.dart';
import '../features/cliente/presentation/providers/carrito_provider.dart';

class App extends StatelessWidget {
  const App({super.key});

  static const seed = Color(0xFFD6ADA7);

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

    return ChangeNotifierProvider(
      create: (_) => CarritoProvider(),
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Deliv',
        themeMode: ThemeMode.system,
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
            bodyMedium: TextStyle(),
          ),
        ),
        routerConfig: router,
      ),
    );
  }
}
