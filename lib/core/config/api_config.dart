class ApiConfig {
  // URL base del backend - cambiar según el entorno
  // Para Android/iOS emulador: usar 10.0.2.2 en lugar de localhost
  // Para web: usar localhost o 127.0.0.1
  // Para dispositivo físico: usar la IP de tu máquina en la red local
  
  static const String baseUrl = 'http://localhost:9090';

  // Prefix común para los endpoints REST
  static const String _apiPrefix = '/api/v1';
  static const String authPath = '$_apiPrefix/auth';
  static const String productosPath = '$_apiPrefix/productos';
  static const String categoriasPath = '$_apiPrefix/categorias';
  static const String pedidosPath = '$_apiPrefix/pedidos';
  static const String personasPath = '$_apiPrefix/personas';
  static const String rolesPath = '$_apiPrefix/roles';
  static const String repartidoresPath = '$_apiPrefix/repartidores';
  static const String usuariosPath = '$_apiPrefix/usuarios';
  
  // Para Android emulador, descomenta la siguiente línea:
  // static const String baseUrl = 'http://10.0.2.2:9090';
  
  // Para dispositivo físico, reemplaza con tu IP local:
  // static const String baseUrl = 'http://192.168.1.X:9090';
  
  static String api(String path) {
    final normalized = path.startsWith('/') ? path : '/$path';
    return '$baseUrl$normalized';
  }

  static String get loginEndpoint => api('$authPath/login');
  static String get registerEndpoint => api('$authPath/register');
}


