import '../repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<void> call({required String username, required String password}) {
    return repository.register(username: username, password: password);
  }
}

