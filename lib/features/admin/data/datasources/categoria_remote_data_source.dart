import '../../../../core/config/api_config.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/categoria.dart';
import '../models/categoria_model.dart';

class CategoriaRemoteDataSource {
  CategoriaRemoteDataSource({required this.apiClient});

  final ApiClient apiClient;

  Future<List<CategoriaModel>> getCategorias() async {
    final response = await apiClient.get(ApiConfig.categoriasPath, requiresAuth: false);
    if (response is! List) {
      return const [];
    }
    return response
        .whereType<Map<String, dynamic>>()
        .map(CategoriaModel.fromJson)
        .toList();
  }

  Future<void> createCategoria(Categoria categoria) async {
    final model = CategoriaModel.fromEntity(categoria);
    await apiClient.post(
      ApiConfig.categoriasPath,
      requiresAuth: true,
      body: {'nombre': model.nombre},
    );
  }

  Future<void> updateCategoria(Categoria categoria) async {
    final model = CategoriaModel.fromEntity(categoria);
    final categoriaId = int.tryParse(model.id);

    if (categoriaId == null) {
      throw ArgumentError('ID de categoría inválido');
    }

    await apiClient.put(
      '${ApiConfig.categoriasPath}/$categoriaId',
      requiresAuth: true,
      body: {'nombre': model.nombre},
    );
  }

  Future<void> deleteCategoria(String id) async {
    final categoriaId = int.tryParse(id);
    if (categoriaId == null) {
      throw ArgumentError('ID de categoría inválido');
    }

    await apiClient.delete(
      '${ApiConfig.categoriasPath}/$categoriaId',
      requiresAuth: true,
    );
  }
}

