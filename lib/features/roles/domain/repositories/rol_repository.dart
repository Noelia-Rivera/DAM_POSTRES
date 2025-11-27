import '../entities/rol.dart';

abstract class RolRepository {
  Future<List<Rol>> getRoles();
  Future<Rol> getRolById(String id);
  Future<Rol> createRol(Rol rol);
  Future<Rol> updateRol(String id, Rol rol);
  Future<void> deleteRol(String id);
}
