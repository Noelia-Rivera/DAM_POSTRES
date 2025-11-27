import '../../../../core/config/api_config.dart';
import '../../../../core/network/api_client.dart';
import '../models/usuario_model.dart';

class UsuarioRemoteDataSource {
  UsuarioRemoteDataSource({required this.apiClient});

  final ApiClient apiClient;

  // Asignar perfil a usuario (ADMIN)
  Future<UsuarioModel> asignarPerfil(String usuarioId, {String? idPersona, String? idRepartidor}) async {
    final body = <String, dynamic>{};
    if (idPersona != null) body['idPersona'] = int.tryParse(idPersona) ?? idPersona;
    if (idRepartidor != null) body['idRepartidor'] = int.tryParse(idRepartidor) ?? idRepartidor;

    final response = await apiClient.put(
      '${ApiConfig.usuariosPath}/$usuarioId/perfil',
      body: body,
    );
    return UsuarioModel.fromJson(response as Map<String, dynamic>);
  }
}
