import 'dart:io';

import '../entities/producto.dart';

abstract class ProductoRepository {
  Future<List<Producto>> getProductos();
  Future<Producto> getProductoById(String id);
  Future<List<Producto>> getProductosByCategoria(String categoria);
  Future<void> createProducto(Producto producto);
  Future<Producto> createProductoWithImage(Producto producto, File imageFile);
  Future<void> updateProducto(Producto producto);
  Future<void> deleteProducto(String id);
}
