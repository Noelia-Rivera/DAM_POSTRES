import '../../domain/entities/usuario.dart';
import '../../domain/repositories/usuario_repository.dart';
import '../datasources/usuario_remote_data_source.dart';

class UsuarioRepositoryImpl implements UsuarioRepository {
  final UsuarioRemoteDataSource remoteDataSource;

  UsuarioRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Usuario> asignarPerfil(String usuarioId, {String? idPersona, String? idRepartidor}) async {
    return await remoteDataSource.asignarPerfil(
      usuarioId,
      idPersona: idPersona,
      idRepartidor: idRepartidor,
    );
  }
}
