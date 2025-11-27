class Producto {
  final String id;
  final String nombre;
  final double precio;
  final String? imagenUrl;
  final String categoria;
  final String? descripcion;
  final String? categoriaId;

  const Producto({
    required this.id,
    required this.nombre,
    required this.precio,
    this.imagenUrl,
    required this.categoria,
    this.descripcion,
    this.categoriaId,
  });
}
