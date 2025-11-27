import '../entities/categoria.dart';
import '../repositories/categoria_repository.dart';

class CreateCategoriaUseCase {
  final CategoriaRepository repository;

  CreateCategoriaUseCase(this.repository);

  Future<void> call(Categoria categoria) async {
    await repository.createCategoria(categoria);
  }
}
