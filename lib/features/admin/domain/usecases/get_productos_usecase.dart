import '../entities/producto.dart';
import '../repositories/producto_repository.dart';

class GetProductosUseCase {
  final ProductoRepository repository;

  GetProductosUseCase(this.repository);

  Future<List<Producto>> call({String? categoria}) async {
    if (categoria != null && categoria.isNotEmpty) {
      return await repository.getProductosByCategoria(categoria);
    }
    return await repository.getProductos();
  }
}
