import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import '../services/auth_service.dart';
import 'exceptions.dart';

class ApiClient {
  ApiClient({
    http.Client? httpClient,
    AuthService? authService,
    String? baseUrl,
  })  : _http = httpClient ?? http.Client(),
        _authService = authService ?? AuthService(),
        _baseUrl = baseUrl ?? ApiConfig.baseUrl;

  final http.Client _http;
  final AuthService _authService;
  final String _baseUrl;

  Uri _buildUri(
    String path, [
    Map<String, dynamic>? queryParameters,
  ]) {
    final normalizedPath = path.startsWith('/') ? path : '/$path';
    return Uri.parse('$_baseUrl$normalizedPath').replace(
      queryParameters: queryParameters?.map(
        (key, value) => MapEntry(key, value?.toString() ?? ''),
      ),
    );
  }

  Future<Map<String, String>> _buildHeaders({
    bool requiresAuth = true,
    Map<String, String>? headers,
  }) async {
    final mergedHeaders = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      ...?headers,
    };

    if (requiresAuth) {
      final token = await _authService.getAccessToken();
      if (token == null || token.isEmpty) {
        throw const UnauthorizedException(
          message: 'Sesión no válida. Inicia sesión nuevamente.',
        );
      }
      mergedHeaders['Authorization'] = 'Bearer $token';
    }

    return mergedHeaders;
  }

  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    bool requiresAuth = true,
  }) async {
    final uri = _buildUri(path, queryParameters);
    final response = await _http.get(
      uri,
      headers: await _buildHeaders(
        requiresAuth: requiresAuth,
        headers: headers,
      ),
    );
    return _handleResponse(response);
  }

  Future<dynamic> post(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    Object? body,
    bool requiresAuth = true,
  }) async {
    final uri = _buildUri(path, queryParameters);
    final response = await _http.post(
      uri,
      headers: await _buildHeaders(
        requiresAuth: requiresAuth,
        headers: headers,
      ),
      body: _encodeBody(body),
    );
    return _handleResponse(response);
  }

  Future<dynamic> put(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    Object? body,
    bool requiresAuth = true,
  }) async {
    final uri = _buildUri(path, queryParameters);
    final response = await _http.put(
      uri,
      headers: await _buildHeaders(
        requiresAuth: requiresAuth,
        headers: headers,
      ),
      body: _encodeBody(body),
    );
    return _handleResponse(response);
  }

  Future<dynamic> delete(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    Object? body,
    bool requiresAuth = true,
  }) async {
    final uri = _buildUri(path, queryParameters);
    final response = await _http.delete(
      uri,
      headers: await _buildHeaders(
        requiresAuth: requiresAuth,
        headers: headers,
      ),
      body: _encodeBody(body),
    );
    return _handleResponse(response);
  }

  Object? _encodeBody(Object? body) {
    if (body == null) {
      return null;
    }

    if (body is String) {
      return body;
    }

    return jsonEncode(body);
  }

  dynamic _handleResponse(http.Response response) {
    final statusCode = response.statusCode;
    final rawBody = response.body;
    dynamic data;
    if (rawBody.isNotEmpty) {
      try {
        data = jsonDecode(rawBody);
      } catch (_) {
        data = rawBody;
      }
    }

    final isSuccess = statusCode >= 200 && statusCode < 300;
    if (isSuccess) {
      return data;
    }

    switch (statusCode) {
      case 400:
        throw BadRequestException(
          message: _extractMessage(data) ?? 'Solicitud inválida',
          statusCode: statusCode,
        );
      case 401:
        throw UnauthorizedException(
          message: _extractMessage(data) ?? 'No autorizado',
        );
      case 403:
        throw ForbiddenException(
          message: _extractMessage(data) ?? 'No tienes permisos para esta acción',
        );
      case 404:
        throw NotFoundException(
          message: _extractMessage(data) ?? 'Recurso no encontrado',
        );
      default:
        if (statusCode >= 500) {
          throw ServerException(
            message: _extractMessage(data) ?? 'Error interno del servidor',
            statusCode: statusCode,
            data: data,
          );
        }

        throw ApiException(
          message: _extractMessage(data) ?? 'Error inesperado',
          statusCode: statusCode,
          data: data,
        );
    }
  }

  String? _extractMessage(dynamic data) {
    if (data == null) return null;
    if (data is Map<String, dynamic>) {
      if (data['message'] is String) return data['message'] as String;
      if (data['error'] is String) return data['error'] as String;
    }
    return null;
  }

  void close() {
    _http.close();
  }
}

