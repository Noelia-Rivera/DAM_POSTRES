import '../entities/categoria.dart';

abstract class CategoriaRepository {
  Future<List<Categoria>> getCategorias();
  Future<void> createCategoria(Categoria categoria);
  Future<void> updateCategoria(Categoria categoria);
  Future<void> deleteCategoria(String id);
}
