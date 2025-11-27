import '../network/api_client.dart';

// Auth
import '../../features/auth/data/datasources/auth_remote_data_source_impl.dart';
import '../config/api_config.dart';

// Admin - Categorias y Productos
import '../../features/admin/data/datasources/categoria_remote_data_source.dart';
import '../../features/admin/data/datasources/producto_remote_data_source.dart';
import '../../features/admin/data/repositories/categoria_repository_impl.dart';
import '../../features/admin/data/repositories/producto_repository_impl.dart';

// Pedidos
import '../../features/pedidos/data/datasources/pedido_remote_data_source_impl.dart';
import '../../features/pedidos/data/repositories/pedido_repository_impl.dart';

// Personas
import '../../features/personas/data/datasources/persona_remote_data_source.dart';
import '../../features/personas/data/repositories/persona_repository_impl.dart';

// Roles
import '../../features/roles/data/datasources/rol_remote_data_source.dart';
import '../../features/roles/data/repositories/rol_repository_impl.dart';

// Repartidores
import '../../features/repartidor/data/datasources/repartidor_remote_data_source_impl.dart';

// Usuarios
import '../../features/usuarios/data/datasources/usuario_remote_data_source.dart';
import '../../features/usuarios/data/repositories/usuario_repository_impl.dart';

/// Clase centralizada para acceder a todos los servicios de la API
class ApiServices {
  ApiServices._();
  
  static ApiClient? _apiClient;
  
  static ApiClient get apiClient {
    _apiClient ??= ApiClient();
    return _apiClient!;
  }

  // ============ AUTH ============
  static AuthRemoteDataSourceImpl get authDataSource => 
      AuthRemoteDataSourceImpl(baseUrl: ApiConfig.baseUrl);

  // ============ CATEGORIAS ============
  static CategoriaRemoteDataSource get categoriaDataSource =>
      CategoriaRemoteDataSource(apiClient: apiClient);
  
  static CategoriaRepositoryImpl get categoriaRepository =>
      CategoriaRepositoryImpl(remoteDataSource: categoriaDataSource);

  // ============ PRODUCTOS ============
  static ProductoRemoteDataSource get productoDataSource =>
      ProductoRemoteDataSource(apiClient: apiClient);
  
  static ProductoRepositoryImpl get productoRepository =>
      ProductoRepositoryImpl(remoteDataSource: productoDataSource);

  // ============ PEDIDOS ============
  static PedidoRemoteDataSourceImpl get pedidoDataSource =>
      PedidoRemoteDataSourceImpl(apiClient: apiClient);
  
  static PedidoRepositoryImpl get pedidoRepository =>
      PedidoRepositoryImpl(remoteDataSource: pedidoDataSource);

  // ============ PERSONAS ============
  static PersonaRemoteDataSource get personaDataSource =>
      PersonaRemoteDataSource(apiClient: apiClient);
  
  static PersonaRepositoryImpl get personaRepository =>
      PersonaRepositoryImpl(remoteDataSource: personaDataSource);

  // ============ ROLES ============
  static RolRemoteDataSource get rolDataSource =>
      RolRemoteDataSource(apiClient: apiClient);
  
  static RolRepositoryImpl get rolRepository =>
      RolRepositoryImpl(remoteDataSource: rolDataSource);

  // ============ REPARTIDORES ============
  static RepartidorRemoteDataSourceImpl get repartidorDataSource =>
      RepartidorRemoteDataSourceImpl(apiClient: apiClient);

  // ============ USUARIOS ============
  static UsuarioRemoteDataSource get usuarioDataSource =>
      UsuarioRemoteDataSource(apiClient: apiClient);
  
  static UsuarioRepositoryImpl get usuarioRepository =>
      UsuarioRepositoryImpl(remoteDataSource: usuarioDataSource);
}
