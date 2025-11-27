import '../../domain/entities/producto.dart';
import '../../domain/repositories/producto_repository.dart';
import '../datasources/producto_remote_data_source.dart';

class ProductoRepositoryImpl implements ProductoRepository {
  final ProductoRemoteDataSource remoteDataSource;

  ProductoRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Producto>> getProductos() async {
    return await remoteDataSource.getProductos();
  }

  @override
  Future<List<Producto>> getProductosByCategoria(String categoria) async {
    final productos = await remoteDataSource.getProductos();
    return productos.where((p) => p.categoria == categoria).toList();
  }

  @override
  Future<void> createProducto(Producto producto) async {
    await remoteDataSource.createProducto(producto);
  }

  @override
  Future<void> updateProducto(Producto producto) async {
    await remoteDataSource.updateProducto(producto);
  }
}
