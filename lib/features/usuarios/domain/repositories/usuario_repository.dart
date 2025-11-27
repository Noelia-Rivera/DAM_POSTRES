import '../entities/usuario.dart';

abstract class UsuarioRepository {
  Future<Usuario> asignarPerfil(String usuarioId, {String? idPersona, String? idRepartidor});
}
