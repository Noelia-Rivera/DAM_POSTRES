import '../entities/producto.dart';

abstract class ProductoRepository {
  Future<List<Producto>> getProductos();
  Future<List<Producto>> getProductosByCategoria(String categoria);
  Future<void> createProducto(Producto producto);
  Future<void> updateProducto(Producto producto);
}
