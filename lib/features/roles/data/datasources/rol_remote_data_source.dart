import '../../../../core/config/api_config.dart';
import '../../../../core/network/api_client.dart';
import '../models/rol_model.dart';

class RolRemoteDataSource {
  RolRemoteDataSource({required this.apiClient});

  final ApiClient apiClient;

  Future<List<RolModel>> getRoles() async {
    final response = await apiClient.get(ApiConfig.rolesPath);
    if (response is! List) return const [];
    return response
        .whereType<Map<String, dynamic>>()
        .map(RolModel.fromJson)
        .toList();
  }

  Future<RolModel> getRolById(String id) async {
    final response = await apiClient.get('${ApiConfig.rolesPath}/$id');
    return RolModel.fromJson(response as Map<String, dynamic>);
  }

  Future<RolModel> createRol(RolModel rol) async {
    final response = await apiClient.post(
      ApiConfig.rolesPath,
      body: rol.toJson(),
    );
    return RolModel.fromJson(response as Map<String, dynamic>);
  }

  Future<RolModel> updateRol(String id, RolModel rol) async {
    final response = await apiClient.put(
      '${ApiConfig.rolesPath}/$id',
      body: rol.toJson(),
    );
    return RolModel.fromJson(response as Map<String, dynamic>);
  }

  Future<void> deleteRol(String id) async {
    await apiClient.delete('${ApiConfig.rolesPath}/$id');
  }
}
