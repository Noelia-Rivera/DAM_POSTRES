import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/auth/presentation/pages/welcome_screen.dart';
import '../../features/auth/presentation/pages/login_screen.dart';
import '../../features/auth/presentation/pages/signup_screen.dart';
import '../../features/auth/presentation/pages/signup_step2_screen.dart';
import '../../features/home/presentation/pages/home_screen.dart';
import '../../features/profile/presentation/pages/profile_screen.dart';
import '../../features/pedidos/presentation/pages/pedidos_screen.dart';
import '../../features/pedidos/presentation/pages/pedido_detalle_screen.dart';
import '../../features/pedidos/presentation/pages/pedido_confirmacion_screen.dart';
import '../../features/pedidos/presentation/bloc/pedido_bloc.dart';
import '../../features/pedidos/domain/usecases/get_pedidos_usecase.dart';
import '../../features/pedidos/data/repositories/pedido_repository_impl.dart';
import '../../features/pedidos/data/datasources/pedido_mock_data_source.dart';
import '../../features/pedidos/domain/entities/pedido.dart';
import '../../features/admin/presentation/pages/vista_admin.dart';
import '../../features/admin/presentation/pages/vista_agregar.dart';
import '../../features/admin/presentation/pages/vista_categoria.dart';
import '../../features/admin/presentation/bloc/admin_bloc.dart';
import '../../features/admin/presentation/bloc/categoria_bloc.dart';
import '../../features/admin/domain/usecases/get_productos_usecase.dart';
import '../../features/admin/domain/usecases/create_producto_usecase.dart';
import '../../features/admin/domain/usecases/update_producto_usecase.dart';
import '../../features/admin/domain/usecases/get_categorias_usecase.dart';
import '../../features/admin/domain/usecases/create_categoria_usecase.dart';
import '../../features/admin/domain/usecases/update_categoria_usecase.dart';
import '../../features/admin/domain/usecases/delete_categoria_usecase.dart';
import '../../features/admin/data/repositories/producto_repository_impl.dart';
import '../../features/admin/data/repositories/categoria_repository_impl.dart';
import '../../features/admin/data/datasources/producto_remote_data_source.dart';
import '../../features/admin/data/datasources/categoria_remote_data_source.dart';
import '../../features/repartidor/presentation/pages/repartidor_dashboard_screen.dart';
import '../../features/repartidor/presentation/pages/repartidor_home_screen.dart';
import '../../features/repartidor/presentation/pages/repartidor_pedidos_screen.dart';
import '../../features/repartidor/presentation/pages/repartidor_pedido_detalle_screen.dart';
import '../../features/repartidor/presentation/bloc/repartidor_bloc.dart';
import '../../features/repartidor/domain/usecases/get_repartidor_info_usecase.dart';
import '../../features/repartidor/domain/usecases/get_pedidos_asignados_usecase.dart';
import '../../features/repartidor/domain/usecases/actualizar_estado_pedido_usecase.dart';
import '../../features/repartidor/domain/usecases/gestionar_turno_usecase.dart';
import '../../features/repartidor/data/repositories/repartidor_repository_impl.dart';
import '../../features/repartidor/data/datasources/repartidor_mock_data_source.dart';
import '../../features/cliente/presentation/pages/cliente_home_screen.dart';
import '../../features/auth/data/datasources/auth_remote_data_source_impl.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/register_usecase.dart';
import '../../features/auth/presentation/bloc/login_bloc.dart';
import '../../features/auth/presentation/bloc/register_bloc.dart';
import '../services/auth_service.dart';
import '../config/api_config.dart';
import '../widgets/auth_guard.dart';
import '../network/api_client.dart';

final authService = AuthService();
final apiClient = ApiClient(authService: authService);

final router = GoRouter(
  initialLocation: '/',
  redirect: (context, state) {
    // Redirect síncrono - solo verifica la ruta, no la autenticación
    // La autenticación se verifica en AuthGuard
    return null;
  },
  routes: [
    GoRoute(path: '/', builder: (context, state) => const WelcomeScreen()),
    GoRoute(
      path: '/login',
      builder: (context, state) {
        final dataSource = AuthRemoteDataSourceImpl(baseUrl: ApiConfig.baseUrl);
        final repository = AuthRepositoryImpl(remoteDataSource: dataSource);
        final useCase = LoginUseCase(repository);
        return BlocProvider(
          create: (_) => LoginBloc(
            loginUseCase: useCase,
            authService: authService,
          ),
          child: const LoginScreen(),
        );
      },
    ),
    GoRoute(path: '/signup', builder: (context, state) => const SignUpScreen()),
    GoRoute(
      path: '/signup/step2',
      builder: (context, state) {
        final dataSource = AuthRemoteDataSourceImpl(baseUrl: ApiConfig.baseUrl);
        final repository = AuthRepositoryImpl(remoteDataSource: dataSource);
        final useCase = RegisterUseCase(repository);
        return BlocProvider(
          create: (_) => RegisterBloc(registerUseCase: useCase),
          child: const SignUpStep2Screen(),
        );
      },
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const AuthGuard(
        child: HomeScreen(),
      ),
    ),
    GoRoute(
      path: '/cliente',
      builder: (context, state) => const AuthGuard(
        child: ClienteHomeScreen(),
        requiredRole: 'CLIENTE',
      ),
    ),
    GoRoute(
      path: '/pedidos',
      builder: (context, state) => AuthGuard(
        child: BlocProvider(
          create: (context) => PedidoBloc(
            getPedidosUseCase: GetPedidosUseCase(
              PedidoRepositoryImpl(
                remoteDataSource: PedidoMockDataSource(),
              ),
            ),
          ),
          child: const PedidosScreen(),
        ),
      ),
    ),
    GoRoute(
      path: '/pedidos/detalle',
      builder: (context, state) {
        final pedido = state.extra as Pedido?;
        if (pedido == null) {
          return const Scaffold(
            body: Center(child: Text('Pedido no encontrado')),
          );
        }
        return AuthGuard(
          child: PedidoDetalleScreen(pedido: pedido),
        );
      },
    ),
    GoRoute(
      path: '/pedidos/confirmacion',
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>?;
        if (data == null || data['pedido'] == null || data['direccion'] == null) {
          return const Scaffold(
            body: Center(child: Text('Datos de pedido no encontrados')),
          );
        }
        return AuthGuard(
          child: PedidoConfirmacionScreen(
            pedido: data['pedido'] as Pedido,
            direccion: data['direccion'] as String,
          ),
        );
      },
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const AuthGuard(
        child: ProfileScreen(),
      ),
    ),
    GoRoute(
      path: '/admin',
      builder: (context, state) {
        final productoRepository = ProductoRepositoryImpl(
          remoteDataSource: ProductoRemoteDataSource(apiClient: apiClient),
        );
        final categoriaRepository = CategoriaRepositoryImpl(
          remoteDataSource: CategoriaRemoteDataSource(apiClient: apiClient),
        );
        return AuthGuard(
          requiredRole: 'ADMIN',
          child: MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => AdminBloc(
                  getProductosUseCase: GetProductosUseCase(productoRepository),
                  createProductoUseCase: CreateProductoUseCase(productoRepository),
                  updateProductoUseCase: UpdateProductoUseCase(productoRepository),
                ),
              ),
              BlocProvider(
                create: (context) => CategoriaBloc(
                  getCategoriasUseCase: GetCategoriasUseCase(categoriaRepository),
                  createCategoriaUseCase: CreateCategoriaUseCase(categoriaRepository),
                  updateCategoriaUseCase: UpdateCategoriaUseCase(categoriaRepository),
                  deleteCategoriaUseCase: DeleteCategoriaUseCase(categoriaRepository),
                ),
              ),
            ],
            child: const VistaAdmin(),
          ),
        );
      },
    ),
    GoRoute(
      path: '/admin/agregar',
      builder: (context, state) {
        final productoRepository = ProductoRepositoryImpl(
          remoteDataSource: ProductoRemoteDataSource(apiClient: apiClient),
        );
        final categoriaRepository = CategoriaRepositoryImpl(
          remoteDataSource: CategoriaRemoteDataSource(apiClient: apiClient),
        );
        return AuthGuard(
          requiredRole: 'ADMIN',
          child: MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => AdminBloc(
                  getProductosUseCase: GetProductosUseCase(productoRepository),
                  createProductoUseCase: CreateProductoUseCase(productoRepository),
                  updateProductoUseCase: UpdateProductoUseCase(productoRepository),
                ),
              ),
              BlocProvider(
                create: (context) => CategoriaBloc(
                  getCategoriasUseCase: GetCategoriasUseCase(categoriaRepository),
                  createCategoriaUseCase: CreateCategoriaUseCase(categoriaRepository),
                  updateCategoriaUseCase: UpdateCategoriaUseCase(categoriaRepository),
                  deleteCategoriaUseCase: DeleteCategoriaUseCase(categoriaRepository),
                ),
              ),
            ],
            child: const VistaAgregar(),
          ),
        );
      },
    ),
    GoRoute(
      path: '/admin/categorias',
      builder: (context, state) {
        final categoriaRepository = CategoriaRepositoryImpl(
          remoteDataSource: CategoriaRemoteDataSource(apiClient: apiClient),
        );
        return AuthGuard(
          requiredRole: 'ADMIN',
          child: BlocProvider(
            create: (context) => CategoriaBloc(
              getCategoriasUseCase: GetCategoriasUseCase(categoriaRepository),
              createCategoriaUseCase: CreateCategoriaUseCase(categoriaRepository),
              updateCategoriaUseCase: UpdateCategoriaUseCase(categoriaRepository),
              deleteCategoriaUseCase: DeleteCategoriaUseCase(categoriaRepository),
            ),
            child: const VistaCategoria(),
          ),
        );
      },
    ),
    GoRoute(
      path: '/repartidor',
      builder: (context, state) {
        final repository = RepartidorRepositoryImpl(
          remoteDataSource: RepartidorMockDataSource(),
        );
        return AuthGuard(
          requiredRole: 'REPARTIDOR',
          child: BlocProvider(
            create: (context) => RepartidorBloc(
              getRepartidorInfoUseCase: GetRepartidorInfoUseCase(repository),
              getPedidosAsignadosUseCase: GetPedidosAsignadosUseCase(repository),
              actualizarEstadoPedidoUseCase: ActualizarEstadoPedidoUseCase(repository),
              gestionarTurnoUseCase: GestionarTurnoUseCase(repository),
            ),
            child: const RepartidorHomeScreen(),
          ),
        );
      },
    ),
    GoRoute(
      path: '/repartidor/pedidos',
      builder: (context, state) {
        final repository = RepartidorRepositoryImpl(
          remoteDataSource: RepartidorMockDataSource(),
        );
        return AuthGuard(
          requiredRole: 'REPARTIDOR',
          child: BlocProvider(
            create: (context) => RepartidorBloc(
              getRepartidorInfoUseCase: GetRepartidorInfoUseCase(repository),
              getPedidosAsignadosUseCase: GetPedidosAsignadosUseCase(repository),
              actualizarEstadoPedidoUseCase: ActualizarEstadoPedidoUseCase(repository),
              gestionarTurnoUseCase: GestionarTurnoUseCase(repository),
            ),
            child: const RepartidorPedidosScreen(),
          ),
        );
      },
    ),
    GoRoute(
      path: '/repartidor/pedidos/detalle',
      builder: (context, state) {
        final pedido = state.extra as Pedido?;
        if (pedido == null) {
          return const Scaffold(
            body: Center(child: Text('Pedido no encontrado')),
          );
        }
        final repository = RepartidorRepositoryImpl(
          remoteDataSource: RepartidorMockDataSource(),
        );
        return AuthGuard(
          requiredRole: 'REPARTIDOR',
          child: BlocProvider(
            create: (context) => RepartidorBloc(
              getRepartidorInfoUseCase: GetRepartidorInfoUseCase(repository),
              getPedidosAsignadosUseCase: GetPedidosAsignadosUseCase(repository),
              actualizarEstadoPedidoUseCase: ActualizarEstadoPedidoUseCase(repository),
              gestionarTurnoUseCase: GestionarTurnoUseCase(repository),
            ),
            child: RepartidorPedidoDetalleScreen(pedido: pedido),
          ),
        );
      },
    ),
  ],
);
