import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/auth/domain/entities/user.dart';

class AuthService {
  static const String _userKey = 'user_data';
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';

  // Guardar usuario y tokens después del login
  Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode({
      'idUsuario': user.idUsuario,
      'username': user.username,
      'profileFotoUrl': user.profileFotoUrl,
      'roles': user.roles,
    }));
    await prefs.setString(_accessTokenKey, user.accessToken);
    await prefs.setString(_refreshTokenKey, user.refreshToken);
  }

  // Obtener usuario guardado
  Future<User?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
    final accessToken = prefs.getString(_accessTokenKey);
    final refreshToken = prefs.getString(_refreshTokenKey);

    if (userJson == null || accessToken == null || refreshToken == null) {
      return null;
    }

    try {
      final userData = jsonDecode(userJson) as Map<String, dynamic>;
      return User(
        idUsuario: userData['idUsuario'] as int,
        username: userData['username'] as String,
        profileFotoUrl: userData['profileFotoUrl'] as String? ?? '',
        roles: (userData['roles'] as List).map((e) => e.toString()).toList(),
        accessToken: accessToken,
        refreshToken: refreshToken,
      );
    } catch (e) {
      return null;
    }
  }

  // Obtener el rol principal del usuario
  Future<String?> getPrimaryRole() async {
    final user = await getUser();
    if (user == null || user.roles.isEmpty) {
      return null;
    }
    return user.roles.first.toUpperCase();
  }

  // Verificar si el usuario está autenticado
  // IMPORTANTE: Solo retorna true si hay un usuario válido con tokens
  Future<bool> isAuthenticated() async {
    final user = await getUser();
    if (user == null) {
      return false;
    }
    
    // Verificar que tenga tokens válidos (no vacíos)
    if (user.accessToken.isEmpty || user.refreshToken.isEmpty) {
      // Si no hay tokens, limpiar la sesión
      await logout();
      return false;
    }
    
    return true;
  }

  // Cerrar sesión
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_refreshTokenKey);
  }

  // Obtener el access token
  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessTokenKey);
  }

  Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_refreshTokenKey);
  }
}

