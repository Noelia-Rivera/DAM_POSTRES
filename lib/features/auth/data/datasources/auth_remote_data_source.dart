import '../../domain/entities/user.dart';

abstract class AuthRemoteDataSource {
  Future<User> login({required String username, required String password});
  Future<void> register({required String username, required String password});
}
