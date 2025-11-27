class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  const ApiException({
    required this.message,
    this.statusCode,
    this.data,
  });

  @override
  String toString() =>
      'ApiException(statusCode: $statusCode, message: $message, data: $data)';
}

class UnauthorizedException extends ApiException {
  const UnauthorizedException({String message = 'No autorizado'})
      : super(message: message, statusCode: 401);
}

class ForbiddenException extends ApiException {
  const ForbiddenException({String message = 'Acceso denegado'})
      : super(message: message, statusCode: 403);
}

class NotFoundException extends ApiException {
  const NotFoundException({String message = 'Recurso no encontrado'})
      : super(message: message, statusCode: 404);
}

class BadRequestException extends ApiException {
  const BadRequestException({String message = 'Solicitud inválida', int? statusCode})
      : super(message: message, statusCode: statusCode ?? 400);
}

class ServerException extends ApiException {
  const ServerException({String message = 'Error en el servidor', int? statusCode, dynamic data})
      : super(message: message, statusCode: statusCode, data: data);
}

