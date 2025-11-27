import '../entities/categoria.dart';
import '../repositories/categoria_repository.dart';

class UpdateCategoriaUseCase {
  final CategoriaRepository repository;

  UpdateCategoriaUseCase(this.repository);

  Future<void> call(Categoria categoria) async {
    await repository.updateCategoria(categoria);
  }
}
