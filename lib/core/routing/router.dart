import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/auth/presentation/pages/welcome_screen.dart';
import '../../features/auth/presentation/pages/login_screen.dart';
import '../../features/auth/presentation/pages/signup_screen.dart';
import '../../features/auth/presentation/pages/signup_step2_screen.dart';
import '../../features/home/presentation/pages/home_screen.dart';
import '../../features/profile/presentation/pages/profile_screen.dart';
import '../../features/pedidos/presentation/pages/pedidos_screen.dart';
import '../../features/pedidos/presentation/bloc/pedido_bloc.dart';
import '../../features/pedidos/domain/usecases/get_pedidos_usecase.dart';
import '../../features/pedidos/data/repositories/pedido_repository_impl.dart';
import '../../features/pedidos/data/datasources/pedido_mock_data_source.dart';
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
import '../../features/admin/data/datasources/producto_mock_data_source.dart';
import '../../features/admin/data/datasources/categoria_mock_data_source.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const WelcomeScreen()),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(path: '/signup', builder: (context, state) => const SignUpScreen()),
    GoRoute(path: '/signup/step2', builder: (context, state) => const SignUpStep2Screen()),
    GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
    GoRoute(
      path: '/pedidos',
      builder: (context, state) => BlocProvider(
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
    GoRoute(path: '/profile', builder: (context, state) => const ProfileScreen()),
    GoRoute(
      path: '/admin',
      builder: (context, state) {
        final repository = ProductoRepositoryImpl(
          dataSource: ProductoMockDataSource(),
        );
        return BlocProvider(
          create: (context) => AdminBloc(
            getProductosUseCase: GetProductosUseCase(repository),
            createProductoUseCase: CreateProductoUseCase(repository),
            updateProductoUseCase: UpdateProductoUseCase(repository),
          ),
          child: const VistaAdmin(),
        );
      },
    ),
    GoRoute(
      path: '/admin/agregar',
      builder: (context, state) {
        final repository = ProductoRepositoryImpl(
          dataSource: ProductoMockDataSource(),
        );
        return BlocProvider(
          create: (context) => AdminBloc(
            getProductosUseCase: GetProductosUseCase(repository),
            createProductoUseCase: CreateProductoUseCase(repository),
            updateProductoUseCase: UpdateProductoUseCase(repository),
          ),
          child: const VistaAgregar(),
        );
      },
    ),
    GoRoute(
      path: '/admin/categorias',
      builder: (context, state) {
        final repository = CategoriaRepositoryImpl(
          dataSource: CategoriaMockDataSource(),
        );
        return BlocProvider(
          create: (context) => CategoriaBloc(
            getCategoriasUseCase: GetCategoriasUseCase(repository),
            createCategoriaUseCase: CreateCategoriaUseCase(repository),
            updateCategoriaUseCase: UpdateCategoriaUseCase(repository),
            deleteCategoriaUseCase: DeleteCategoriaUseCase(repository),
          ),
          child: const VistaCategoria(),
        );
      },
    ),
  ],
);
