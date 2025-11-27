import '../entities/categoria.dart';
import '../repositories/categoria_repository.dart';

class GetCategoriasUseCase {
  final CategoriaRepository repository;

  GetCategoriasUseCase(this.repository);

  Future<List<Categoria>> call() async {
    return await repository.getCategorias();
  }
}
