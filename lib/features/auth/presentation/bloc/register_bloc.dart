import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/register_usecase.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterUseCase registerUseCase;

  RegisterBloc({
    required this.registerUseCase,
  }) : super(RegisterInitial()) {
    on<RegisterSubmitted>(_onRegisterSubmitted);
  }

  Future<void> _onRegisterSubmitted(
    RegisterSubmitted event,
    Emitter<RegisterState> emit,
  ) async {
    emit(RegisterLoading());
    try {
      await registerUseCase(
        username: event.username,
        password: event.password,
      );
      
      print('✅ [REGISTER] Registro exitoso para: ${event.username}');
      emit(RegisterSuccess());
    } catch (e) {
      final errorMessage = e.toString().replaceFirst('Exception: ', '');
      print('❌ [REGISTER] Error en registro: $errorMessage');
      emit(RegisterFailure(message: errorMessage.isNotEmpty ? errorMessage : 'Error al registrar usuario'));
    }
  }
}

