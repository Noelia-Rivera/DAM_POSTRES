import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../domain/entities/user.dart';
import 'auth_remote_data_source.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final String baseUrl;
  final String? accessToken;

  AuthRemoteDataSourceImpl({required this.baseUrl, this.accessToken});

  @override
  Future<User> login({required String username, required String password}) async {
    try {
      final uri = Uri.parse('$baseUrl/api/v1/auth/login');
      
      print('🔗 [AUTH] Intentando conectar a: $uri');

      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Tiempo de espera agotado. Verifica tu conexión a internet.');
        },
      );

      print('📡 [AUTH] Respuesta recibida: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        try {
          final data = jsonDecode(response.body) as Map<String, dynamic>;
          print('✅ [AUTH] Login exitoso para usuario: ${data['username']}');

          return User(
            idUsuario: data['idUsuario'] as int,
            username: data['username'] as String,
            profileFotoUrl: data['profileFotoUrl'] as String? ?? '',
            roles: (data['roles'] as List).map((e) => e.toString()).toList(),
            accessToken: data['accessToken'] as String,
            refreshToken: data['refreshToken'] as String,
          );
        } catch (e) {
          print('❌ [AUTH] Error al procesar respuesta: $e');
          throw Exception('Error al procesar la respuesta del servidor');
        }
      } else if (response.statusCode == 401) {
        print('❌ [AUTH] Credenciales inválidas');
        throw Exception('Credenciales inválidas');
      } else if (response.statusCode == 404) {
        print('❌ [AUTH] Endpoint no encontrado. URL: $uri');
        throw Exception('Servicio no encontrado. Verifica que el backend esté corriendo en $baseUrl');
      } else {
        print('❌ [AUTH] Error del servidor: ${response.statusCode} - ${response.body}');
        throw Exception('Error del servidor (${response.statusCode})');
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Error de conexión: ${e.toString()}');
    }
  }

  @override
  Future<void> register({required String username, required String password}) async {
    await _registerUser('$baseUrl/api/v1/auth/register', username, password);
  }

  @override
  Future<void> registerAdmin({required String username, required String password}) async {
    await _registerUser('$baseUrl/api/v1/auth/registerAdmin', username, password);
  }

  @override
  Future<void> registerRepartidor({
    required String username,
    required String password,
    required String codigo,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/api/v1/auth/registerRepartidor');
      
      print('🔗 [AUTH] Registrando repartidor: $username');

      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          if (accessToken != null) 'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          'username': username,
          'password': password,
          'codigo': codigo,
        }),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('✅ [AUTH] Repartidor registrado exitosamente');
        return;
      }
      _handleErrorResponse(response);
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Error de conexión: ${e.toString()}');
    }
  }

  @override
  Future<String> refreshToken(String refreshToken) async {
    try {
      final uri = Uri.parse('$baseUrl/api/v1/auth/refresh');
      
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'refreshToken': refreshToken}),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return data['accessToken'] as String;
      }
      throw Exception('Error al refrescar token');
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Error de conexión: ${e.toString()}');
    }
  }

  @override
  Future<void> logout(String refreshToken) async {
    try {
      final uri = Uri.parse('$baseUrl/api/v1/auth/logout');
      
      await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'refreshToken': refreshToken}),
      ).timeout(const Duration(seconds: 10));
    } catch (e) {
      // Ignorar errores de logout
      print('⚠️ [AUTH] Error en logout: $e');
    }
  }

  @override
  Future<void> uploadProfileImage(String usuarioId, String filePath) async {
    try {
      final uri = Uri.parse('$baseUrl/api/v1/auth/uploadProfileImage/$usuarioId');
      
      final request = http.MultipartRequest('POST', uri);
      request.headers['Accept'] = '*/*';
      if (accessToken != null) {
        request.headers['Authorization'] = 'Bearer $accessToken';
      }
      
      request.files.add(await http.MultipartFile.fromPath('file', filePath));
      
      final streamedResponse = await request.send().timeout(const Duration(seconds: 30));
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Error al subir imagen de perfil');
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Error de conexión: ${e.toString()}');
    }
  }

  Future<void> _registerUser(String url, String username, String password) async {
    try {
      final uri = Uri.parse(url);
      
      print('🔗 [AUTH] Intentando registrar usuario: $username');

      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      ).timeout(const Duration(seconds: 10));

      print('📡 [AUTH] Respuesta de registro recibida: ${response.statusCode}');
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('✅ [AUTH] Registro exitoso para usuario: $username');
        return;
      }
      _handleErrorResponse(response);
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Error de conexión: ${e.toString()}');
    }
  }

  void _handleErrorResponse(http.Response response) {
    if (response.statusCode == 400) {
      final errorBody = jsonDecode(response.body) as Map<String, dynamic>?;
      final errorMessage = errorBody?['message'] as String? ?? 
          'Error en el registro. El usuario ya existe o los datos son inválidos.';
      throw Exception(errorMessage);
    } else if (response.statusCode == 409) {
      throw Exception('El usuario ya existe. Por favor, elige otro nombre de usuario.');
    } else if (response.statusCode == 404) {
      throw Exception('Servicio no encontrado. Verifica que el backend esté corriendo.');
    } else {
      throw Exception('Error del servidor (${response.statusCode})');
    }
  }
}
