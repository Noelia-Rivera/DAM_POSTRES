import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/auth_service.dart';

/// Widget que protege rutas verificando autenticación
class AuthGuard extends StatefulWidget {
  final Widget child;
  final String? requiredRole;

  const AuthGuard({
    super.key,
    required this.child,
    this.requiredRole,
  });

  @override
  State<AuthGuard> createState() => _AuthGuardState();
}

class _AuthGuardState extends State<AuthGuard> {
  final _authService = AuthService();
  bool _isChecking = true;
  bool _isAuthenticated = false;
  String? _userRole;

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final isAuth = await _authService.isAuthenticated();
    if (isAuth) {
      final role = await _authService.getPrimaryRole();
      if (mounted) {
        setState(() {
          _isAuthenticated = true;
          _userRole = role;
          _isChecking = false;
        });
      }
    } else {
      // NO está autenticado - redirigir a login inmediatamente
      if (mounted) {
        // Usar WidgetsBinding para evitar problemas de contexto
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            context.go('/login');
          }
        });
        setState(() {
          _isChecking = false;
          _isAuthenticated = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isChecking) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Si no está autenticado, mostrar loading mientras redirige
    // Nunca mostrar el contenido si no está autenticado
    if (!_isAuthenticated) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Si se requiere un rol específico, verificar
    if (widget.requiredRole != null && _userRole != widget.requiredRole) {
      // Redirigir según el rol del usuario
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          if (_userRole == 'ADMIN') {
            context.go('/admin');
          } else if (_userRole == 'REPARTIDOR') {
            context.go('/repartidor');
          } else if (_userRole == 'CLIENTE') {
            context.go('/cliente');
          } else {
            context.go('/login');
          }
        }
      });
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return widget.child;
  }
}

