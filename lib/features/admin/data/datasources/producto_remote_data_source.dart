import 'dart:io';

import '../../../../core/config/api_config.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/producto.dart';
import '../models/producto_model.dart';

class ProductoRemoteDataSource {
  ProductoRemoteDataSource({required this.apiClient});

  final ApiClient apiClient;

  Future<List<ProductoModel>> getProductos() async {
    final response = await apiClient.get(ApiConfig.productosPath, requiresAuth: false);
    if (response is! List) {
      return const [];
    }
    return response
        .whereType<Map<String, dynamic>>()
        .map(ProductoModel.fromJson)
        .toList();
  }

  Future<void> createProducto(Producto producto) async {
    final model = ProductoModel.fromEntity(producto);

    if (model.categoriaId == null) {
      throw ArgumentError('Debes seleccionar una categoría para crear el producto');
    }

    await apiClient.post(
      ApiConfig.productosPath,
      requiresAuth: true,
      body: model.toDto(),
    );
  }

  Future<void> updateProducto(Producto producto) async {
    final model = ProductoModel.fromEntity(producto);
    final productoId = int.tryParse(model.id);

    if (productoId == null) {
      throw ArgumentError('ID de producto inválido');
    }

    await apiClient.put(
      '${ApiConfig.productosPath}/$productoId',
      requiresAuth: true,
      body: model.toDto(),
    );
  }

  Future<void> deleteProducto(String id) async {
    final productoId = int.tryParse(id);
    if (productoId == null) {
      throw ArgumentError('ID de producto inválido');
    }

    await apiClient.delete(
      '${ApiConfig.productosPath}/$productoId',
      requiresAuth: true,
    );
  }

  Future<ProductoModel> getProductoById(String id) async {
    final response = await apiClient.get(
      '${ApiConfig.productosPath}/$id',
      requiresAuth: false,
    );
    return ProductoModel.fromJson(response as Map<String, dynamic>);
  }

  /// Crea un producto con imagen usando el endpoint /createWithImage
  Future<ProductoModel> createProductoWithImage(Producto producto, File imageFile) async {
    final model = ProductoModel.fromEntity(producto);

    if (model.categoriaId == null) {
      throw ArgumentError('Debes seleccionar una categoría para crear el producto');
    }

    final jsonData = {
      'nombre': model.nombre,
      'precio': model.precio,
      'descripcion': model.descripcion ?? '',
      'idCategoria': int.tryParse(model.categoriaId!) ?? model.categoriaId,
    };

    final response = await apiClient.postMultipart(
      '${ApiConfig.productosPath}/createWithImage',
      file: imageFile,
      jsonData: jsonData,
      requiresAuth: true,
    );

    return ProductoModel.fromJson(response as Map<String, dynamic>);
  }
}

