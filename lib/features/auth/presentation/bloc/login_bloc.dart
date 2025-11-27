import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/user.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../../../core/services/auth_service.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUseCase loginUseCase;
  final AuthService authService;

  LoginBloc({
    required this.loginUseCase,
    required this.authService,
  }) : super(LoginInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());
    try {
      // IMPORTANTE: Solo guardamos la sesión si el login es exitoso
      final user = await loginUseCase(
        username: event.username,
        password: event.password,
      );
      
      // Guardar la sesión del usuario SOLO si el login fue exitoso
      await authService.saveUser(user);
      
      print('✅ [LOGIN] Sesión guardada exitosamente para: ${user.username}');
      emit(LoginSuccess(user: user));
    } catch (e) {
      // IMPORTANTE: Si hay error, NO guardamos la sesión
      // Asegurarnos de que no haya sesión guardada en caso de error
      await authService.logout();
      
      final errorMessage = e.toString().replaceFirst('Exception: ', '');
      print('❌ [LOGIN] Error en login: $errorMessage');
      emit(LoginFailure(message: errorMessage.isNotEmpty ? errorMessage : 'Credenciales inválidas o error de red'));
    }
  }
}
