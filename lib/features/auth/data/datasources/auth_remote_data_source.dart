import '../../domain/entities/user.dart';

abstract class AuthRemoteDataSource {
  Future<User> login({required String username, required String password});
  Future<void> register({required String username, required String password});
  Future<void> registerAdmin({required String username, required String password});
  Future<void> registerRepartidor({required String username, required String password, required String codigo});
  Future<String> refreshToken(String refreshToken);
  Future<void> logout(String refreshToken);
  Future<void> uploadProfileImage(String usuarioId, String filePath);
}
