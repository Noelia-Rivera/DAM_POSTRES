import '../../domain/entities/categoria.dart';
import '../../domain/repositories/categoria_repository.dart';
import '../datasources/categoria_remote_data_source.dart';

class CategoriaRepositoryImpl implements CategoriaRepository {
  final CategoriaRemoteDataSource remoteDataSource;

  CategoriaRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Categoria>> getCategorias() async {
    return await remoteDataSource.getCategorias();
  }

  @override
  Future<void> createCategoria(Categoria categoria) async {
    await remoteDataSource.createCategoria(categoria);
  }

  @override
  Future<void> updateCategoria(Categoria categoria) async {
    await remoteDataSource.updateCategoria(categoria);
  }

  @override
  Future<void> deleteCategoria(String id) async {
    await remoteDataSource.deleteCategoria(id);
  }
}
