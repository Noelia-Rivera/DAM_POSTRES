import '../../domain/entities/usuario.dart';

class UsuarioModel extends Usuario {
  const UsuarioModel({
    required super.id,
    required super.username,
    super.profileFotoUrl,
    super.roles,
    super.idPersona,
    super.idRepartidor,
  });

  factory UsuarioModel.fromJson(Map<String, dynamic> json) {
    final rolesJson = json['roles'] as List?;
    final roles = rolesJson?.map((r) {
      if (r is Map<String, dynamic>) {
        return r['nombre'] as String? ?? '';
      }
      return r.toString();
    }).toList() ?? [];

    return UsuarioModel(
      id: (json['idUsuario'] ?? json['id'])?.toString() ?? '',
      username: json['username'] as String? ?? '',
      profileFotoUrl: json['profileFotoUrl'] as String?,
      roles: roles,
      idPersona: json['persona']?['idPersona']?.toString(),
      idRepartidor: json['repartidor']?['idRepartidor']?.toString(),
    );
  }

  Map<String, dynamic> toPerfilJson() => {
    if (idPersona != null) 'idPersona': int.tryParse(idPersona!) ?? idPersona,
    if (idRepartidor != null) 'idRepartidor': int.tryParse(idRepartidor!) ?? idRepartidor,
  };
}
