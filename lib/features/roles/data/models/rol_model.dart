import '../../domain/entities/rol.dart';

class RolModel extends Rol {
  const RolModel({
    required super.id,
    required super.nombre,
  });

  factory RolModel.fromJson(Map<String, dynamic> json) {
    return RolModel(
      id: (json['idRol'] ?? json['id'])?.toString() ?? '',
      nombre: json['nombre'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'nombre': nombre,
  };

  factory RolModel.fromEntity(Rol rol) {
    return RolModel(
      id: rol.id,
      nombre: rol.nombre,
    );
  }
}
