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
  ],
);
