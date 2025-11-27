class Producto {
  final String id;
  final String nombre;
  final double precio;
  final String? imagenUrl;
  final String categoria;

  Producto({
    required this.id,
    required this.nombre,
    required this.precio,
    this.imagenUrl,
    required this.categoria,
  });
}
