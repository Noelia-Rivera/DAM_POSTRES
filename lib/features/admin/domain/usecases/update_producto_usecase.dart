import '../entities/producto.dart';
import '../repositories/producto_repository.dart';

class UpdateProductoUseCase {
  final ProductoRepository repository;

  UpdateProductoUseCase(this.repository);

  Future<void> call(Producto producto) async {
    await repository.updateProducto(producto);
  }
}
