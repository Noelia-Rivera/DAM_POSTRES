import '../entities/persona.dart';

abstract class PersonaRepository {
  Future<List<Persona>> getPersonas();
  Future<Persona> getPersonaById(String id);
  Future<Persona> createPersona(Persona persona);
  Future<Persona> updatePersona(String id, Persona persona);
  Future<void> deletePersona(String id);
}
