import '../../domain/entities/producto.dart';
import '../../domain/repositories/producto_repository.dart';
import '../datasources/producto_mock_data_source.dart';

class ProductoRepositoryImpl implements ProductoRepository {
  final ProductoMockDataSource dataSource;

  ProductoRepositoryImpl({required this.dataSource});

  @override
  Future<List<Producto>> getProductos() async {
    return await dataSource.getProductos();
  }

  @override
  Future<List<Producto>> getProductosByCategoria(String categoria) async {
    final productos = await dataSource.getProductos();
    return productos.where((p) => p.categoria == categoria).toList();
  }

  @override
  Future<void> createProducto(Producto producto) async {
    await dataSource.createProducto(producto);
  }

  @override
  Future<void> updateProducto(Producto producto) async {
    await dataSource.updateProducto(producto);
  }
}
