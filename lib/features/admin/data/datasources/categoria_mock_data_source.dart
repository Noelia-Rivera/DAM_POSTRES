import '../../domain/entities/categoria.dart';

class CategoriaMockDataSource {
  Future<List<Categoria>> getCategorias() async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    return [
      Categoria(id: '1', nombre: 'Categoria 1'),
      Categoria(id: '2', nombre: 'Categoria 2'),
    ];
  }

  Future<void> createCategoria(Categoria categoria) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  Future<void> updateCategoria(Categoria categoria) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  Future<void> deleteCategoria(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }
}
