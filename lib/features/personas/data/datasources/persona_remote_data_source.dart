import '../../../../core/config/api_config.dart';
import '../../../../core/network/api_client.dart';
import '../models/persona_model.dart';

class PersonaRemoteDataSource {
  PersonaRemoteDataSource({required this.apiClient});

  final ApiClient apiClient;

  Future<List<PersonaModel>> getPersonas() async {
    final response = await apiClient.get(ApiConfig.personasPath);
    if (response is! List) return const [];
    return response
        .whereType<Map<String, dynamic>>()
        .map(PersonaModel.fromJson)
        .toList();
  }

  Future<PersonaModel> getPersonaById(String id) async {
    final response = await apiClient.get('${ApiConfig.personasPath}/$id');
    return PersonaModel.fromJson(response as Map<String, dynamic>);
  }

  Future<PersonaModel> createPersona(PersonaModel persona) async {
    final response = await apiClient.post(
      ApiConfig.personasPath,
      body: persona.toJson(),
    );
    return PersonaModel.fromJson(response as Map<String, dynamic>);
  }

  Future<PersonaModel> updatePersona(String id, PersonaModel persona) async {
    final response = await apiClient.put(
      '${ApiConfig.personasPath}/$id',
      body: persona.toJson(),
    );
    return PersonaModel.fromJson(response as Map<String, dynamic>);
  }

  Future<void> deletePersona(String id) async {
    await apiClient.delete('${ApiConfig.personasPath}/$id');
  }
}
