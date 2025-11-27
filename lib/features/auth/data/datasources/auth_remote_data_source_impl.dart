import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../domain/entities/user.dart';
import 'auth_remote_data_source.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final String baseUrl;

  AuthRemoteDataSourceImpl({required this.baseUrl});

  @override
  Future<User> login({required String username, required String password}) async {
    try {
      final uri = Uri.parse('$baseUrl/api/v1/auth/login');
      
      print('🔗 [AUTH] Intentando conectar a: $uri'); // Debug

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

      print('📡 [AUTH] Respuesta recibida: ${response.statusCode}'); // Debug
      
      if (response.statusCode == 200) {
        try {
          final data = jsonDecode(response.body) as Map<String, dynamic>;
          print('✅ [AUTH] Login exitoso para usuario: ${data['username']}'); // Debug

          return User(
            idUsuario: data['idUsuario'] as int,
            username: data['username'] as String,
            profileFotoUrl: data['profileFotoUrl'] as String? ?? '',
            roles: (data['roles'] as List).map((e) => e.toString()).toList(),
            accessToken: data['accessToken'] as String,
            refreshToken: data['refreshToken'] as String,
          );
        } catch (e) {
          print('❌ [AUTH] Error al procesar respuesta: $e'); // Debug
          throw Exception('Error al procesar la respuesta del servidor');
        }
      } else if (response.statusCode == 401) {
        print('❌ [AUTH] Credenciales inválidas'); // Debug
        throw Exception('Credenciales inválidas');
      } else if (response.statusCode == 404) {
        print('❌ [AUTH] Endpoint no encontrado. URL: $uri'); // Debug
        throw Exception('Servicio no encontrado. Verifica que el backend esté corriendo en $baseUrl');
      } else {
        print('❌ [AUTH] Error del servidor: ${response.statusCode} - ${response.body}'); // Debug
        throw Exception('Error del servidor (${response.statusCode})');
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Error de conexión: ${e.toString()}');
    }
  }

  @override
  Future<void> register({required String username, required String password}) async {
    try {
      final uri = Uri.parse('$baseUrl/api/v1/auth/register');
      
      print('🔗 [AUTH] Intentando registrar usuario: $username'); // Debug

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
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Tiempo de espera agotado. Verifica tu conexión a internet.');
        },
      );

      print('📡 [AUTH] Respuesta de registro recibida: ${response.statusCode}'); // Debug
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('✅ [AUTH] Registro exitoso para usuario: $username'); // Debug
        return;
      } else if (response.statusCode == 400) {
        print('❌ [AUTH] Error en el registro: ${response.body}'); // Debug
        final errorBody = jsonDecode(response.body) as Map<String, dynamic>?;
        final errorMessage = errorBody?['message'] as String? ?? 'Error en el registro. El usuario ya existe o los datos son inválidos.';
        throw Exception(errorMessage);
      } else if (response.statusCode == 409) {
        print('❌ [AUTH] Usuario ya existe'); // Debug
        throw Exception('El usuario ya existe. Por favor, elige otro nombre de usuario.');
      } else if (response.statusCode == 404) {
        print('❌ [AUTH] Endpoint no encontrado. URL: $uri'); // Debug
        throw Exception('Servicio no encontrado. Verifica que el backend esté corriendo en $baseUrl');
      } else {
        print('❌ [AUTH] Error del servidor: ${response.statusCode} - ${response.body}'); // Debug
        throw Exception('Error del servidor (${response.statusCode})');
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Error de conexión: ${e.toString()}');
    }
  }
}
