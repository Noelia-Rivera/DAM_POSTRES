import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/services/auth_service.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final _authService = AuthService();
  bool _isChecking = true;

  @override
  void initState() {
    super.initState();
    _checkAuthAndRedirect();
  }

  Future<void> _checkAuthAndRedirect() async {
    final isAuthenticated = await _authService.isAuthenticated();
    if (isAuthenticated && mounted) {
      final role = await _authService.getPrimaryRole();
      if (role == 'ADMIN') {
        context.go('/admin');
      } else if (role == 'REPARTIDOR') {
        context.go('/repartidor');
      } else if (role == 'CLIENTE') {
        context.go('/cliente');
      }
    }
    if (mounted) {
      setState(() {
        _isChecking = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isChecking) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
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
                      'Hello',
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(fontSize: 36, letterSpacing: -0.5),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),

                    Text(
                      'Welcome to Delivery',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(height: 1.3),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),

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
                          context.go('/login');
                        },
                        child: const Text(
                          'Login',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: BorderSide(
                            color: cs.primary.withOpacity(0.35),
                            width: 2,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(22),
                          ),
                          foregroundColor: cs.primary.withOpacity(0.75),
                        ),
                        onPressed: () {
                          context.go('/signup');
                        },
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Botón temporal para testing
                    TextButton(
                      onPressed: () => context.go('/admin'),
                      child: const Text(
                        'Ir a Admin (Testing)',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ),
                    const SizedBox(height: 16),
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
