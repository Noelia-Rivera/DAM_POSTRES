import '../../domain/entities/categoria.dart';
import '../../domain/repositories/categoria_repository.dart';
import '../datasources/categoria_mock_data_source.dart';

class CategoriaRepositoryImpl implements CategoriaRepository {
  final CategoriaMockDataSource dataSource;

  CategoriaRepositoryImpl({required this.dataSource});

  @override
  Future<List<Categoria>> getCategorias() async {
    return await dataSource.getCategorias();
  }

  @override
  Future<void> createCategoria(Categoria categoria) async {
    await dataSource.createCategoria(categoria);
  }

  @override
  Future<void> updateCategoria(Categoria categoria) async {
    await dataSource.updateCategoria(categoria);
  }

  @override
  Future<void> deleteCategoria(String id) async {
    await dataSource.deleteCategoria(id);
  }
}
