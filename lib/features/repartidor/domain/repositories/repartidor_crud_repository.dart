import '../entities/repartidor.dart';

/// Repositorio para operaciones CRUD de repartidores (ADMIN)
abstract class RepartidorCrudRepository {
  Future<List<Repartidor>> getRepartidores();
  Future<Repartidor> getRepartidorById(String id);
  Future<Repartidor> createRepartidor(String codigo);
  Future<Repartidor> updateRepartidor(String id, String codigo);
  Future<void> deleteRepartidor(String id);
}
