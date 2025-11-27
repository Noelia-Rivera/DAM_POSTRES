import '../repositories/categoria_repository.dart';

class DeleteCategoriaUseCase {
  final CategoriaRepository repository;

  DeleteCategoriaUseCase(this.repository);

  Future<void> call(String id) async {
    await repository.deleteCategoria(id);
  }
}
