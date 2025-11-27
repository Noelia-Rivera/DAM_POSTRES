import '../../domain/entities/producto.dart';

class ProductoModel extends Producto {
  const ProductoModel({
    required super.id,
    required super.nombre,
    required super.precio,
    super.imagenUrl,
    required super.categoria,
    super.descripcion,
    super.categoriaId,
  });

  factory ProductoModel.fromJson(Map<String, dynamic> json) {
    final categoriaJson = json['categoria'] as Map<String, dynamic>?;
    final categoriaNombre = categoriaJson != null
        ? (categoriaJson['nombre'] as String? ?? '')
        : (json['categoria'] as String? ?? '');
    final categoriaId = categoriaJson != null
        ? categoriaJson['idCategoria']?.toString()
        : json['idCategoria']?.toString();

    return ProductoModel(
      id: (json['idProducto'] ?? json['id'])?.toString() ?? '',
      nombre: (json['nombre'] as String?) ?? '',
      precio: (json['precio'] as num?)?.toDouble() ?? 0,
      imagenUrl: json['fotoUrl'] as String?,
      descripcion: json['descripcion'] as String?,
      categoria: categoriaNombre,
      categoriaId: categoriaId,
    );
  }

  Map<String, dynamic> toDto() {
    final parsedCategoriaId = categoriaId != null ? int.tryParse(categoriaId!) : null;
    return {
      'nombre': nombre,
      'precio': precio,
      'descripcion': descripcion ?? '',
      'fotoUrl': imagenUrl,
      'idCategoria': parsedCategoriaId ?? categoriaId,
    }..removeWhere((key, value) => value == null);
  }

  factory ProductoModel.fromEntity(Producto producto) {
    return ProductoModel(
      id: producto.id,
      nombre: producto.nombre,
      precio: producto.precio,
      imagenUrl: producto.imagenUrl,
      categoria: producto.categoria,
      descripcion: producto.descripcion,
      categoriaId: producto.categoriaId,
    );
  }
}

