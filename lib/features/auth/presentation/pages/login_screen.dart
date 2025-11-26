import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 160,
                      child: Stack(
                        children: const [
                          _Bubble(
                            top: 10,
                            left: 60,
                            size: 52,
                            color: Color(0xFFD7B3AF),
                          ),
                          _Bubble(
                            top: 12,
                            right: 60,
                            size: 48,
                            color: Color(0xFFE8DAB6),
                          ),
                          _Bubble(
                            top: 60,
                            left: 8,
                            size: 44,
                            color: Color(0xFFBACB95),
                          ),
                          _Bubble(
                            top: 60,
                            right: 8,
                            size: 44,
                            color: Color(0xFFCDA7A0),
                          ),
                          _Bubble(
                            top: 102,
                            left: 130,
                            size: 50,
                            color: Color(0xFFBACB95),
                          ),
                        ],
                      ),
                    ),

                    const _BagCakeIcon(),
                    const SizedBox(height: 12),

                    Text(
                      'Iniciar Sesión',
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 28,
                            color: Colors.black,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),

                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Usuario',
                        labelStyle: const TextStyle(color: Colors.grey),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: cs.primary.withOpacity(0.6),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey.withOpacity(0.4),
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Contraseña',
                        labelStyle: const TextStyle(color: Colors.grey),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: cs.primary.withOpacity(0.6),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey.withOpacity(0.4),
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          '¿Olvidaste tu contraseña?',
                          style: TextStyle(
                            color: cs.primary.withOpacity(0.7),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(22),
                          ),
                          backgroundColor: cs.primary.withOpacity(0.7),
                          foregroundColor: cs.onPrimary,
                        ),
                        onPressed: () {
                          context.go('/home');
                        },
                        child: const Text(
                          'Sign In',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  final double top;
  final double? left;
  final double? right;
  final double size;
  final Color color;

  const _Bubble({
    required this.top,
    this.left,
    this.right,
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color.withOpacity(0.9),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

class _BagCakeIcon extends StatelessWidget {
  const _BagCakeIcon();

  @override
  Widget build(BuildContext context) {
    final border = Border.all(
      color: Theme.of(context).colorScheme.onSurface,
      width: 3,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Container(
            width: 120,
            height: 18,
            decoration: BoxDecoration(
              border: border,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(height: 4),
          Container(
            width: 160,
            height: 120,
            decoration: BoxDecoration(
              border: border,
              borderRadius: BorderRadius.circular(14),
            ),
            alignment: Alignment.center,
            child: const Icon(Icons.cake_outlined, size: 56),
          ),
        ],
      ),
    );
  }
}
