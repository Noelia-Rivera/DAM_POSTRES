import '../entities/producto.dart';
import '../repositories/producto_repository.dart';

class CreateProductoUseCase {
  final ProductoRepository repository;

  CreateProductoUseCase(this.repository);

  Future<void> call(Producto producto) async {
    await repository.createProducto(producto);
  }
}
