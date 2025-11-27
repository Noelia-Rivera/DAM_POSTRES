import '../../domain/entities/persona.dart';
import '../../domain/repositories/persona_repository.dart';
import '../datasources/persona_remote_data_source.dart';
import '../models/persona_model.dart';

class PersonaRepositoryImpl implements PersonaRepository {
  final PersonaRemoteDataSource remoteDataSource;

  PersonaRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Persona>> getPersonas() async {
    return await remoteDataSource.getPersonas();
  }

  @override
  Future<Persona> getPersonaById(String id) async {
    return await remoteDataSource.getPersonaById(id);
  }

  @override
  Future<Persona> createPersona(Persona persona) async {
    final model = PersonaModel.fromEntity(persona);
    return await remoteDataSource.createPersona(model);
  }

  @override
  Future<Persona> updatePersona(String id, Persona persona) async {
    final model = PersonaModel.fromEntity(persona);
    return await remoteDataSource.updatePersona(id, model);
  }

  @override
  Future<void> deletePersona(String id) async {
    await remoteDataSource.deletePersona(id);
  }
}
