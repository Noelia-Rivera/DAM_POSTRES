import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<User> login({required String username, required String password}) {
    return remoteDataSource.login(username: username, password: password);
  }

  @override
  Future<void> register({required String username, required String password}) {
    return remoteDataSource.register(username: username, password: password);
  }
}
