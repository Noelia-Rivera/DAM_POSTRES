import '../../domain/entities/categoria.dart';

class CategoriaModel extends Categoria {
  const CategoriaModel({
    required super.id,
    required super.nombre,
  });

  factory CategoriaModel.fromJson(Map<String, dynamic> json) {
    final idValue = json['idCategoria'] ?? json['id'];
    return CategoriaModel(
      id: idValue?.toString() ?? '',
      nombre: (json['nombre'] as String?) ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final idNumber = int.tryParse(id);
    return {
      'idCategoria': idNumber ?? id,
      'nombre': nombre,
    };
  }

  factory CategoriaModel.fromEntity(Categoria categoria) {
    return CategoriaModel(
      id: categoria.id,
      nombre: categoria.nombre,
    );
  }
}

