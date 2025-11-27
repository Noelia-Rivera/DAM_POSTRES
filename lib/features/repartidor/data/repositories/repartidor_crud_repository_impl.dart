import '../../domain/entities/repartidor.dart';
import '../../domain/repositories/repartidor_crud_repository.dart';
import '../datasources/repartidor_remote_data_source_impl.dart';
import '../models/repartidor_model.dart';

class RepartidorCrudRepositoryImpl implements RepartidorCrudRepository {
  final RepartidorRemoteDataSourceImpl remoteDataSource;

  RepartidorCrudRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Repartidor>> getRepartidores() async {
    return await remoteDataSource.getRepartidores();
  }

  @override
  Future<Repartidor> getRepartidorById(String id) async {
    return await remoteDataSource.getRepartidorInfo(id);
  }

  @override
  Future<Repartidor> createRepartidor(String codigo) async {
    final model = RepartidorModel(
      id: '',
      nombre: '',
      apellido: '',
      email: '',
      telefono: '',
      codigo: codigo,
    );
    return await remoteDataSource.createRepartidor(model);
  }

  @override
  Future<Repartidor> updateRepartidor(String id, String codigo) async {
    final model = RepartidorModel(
      id: id,
      nombre: '',
      apellido: '',
      email: '',
      telefono: '',
      codigo: codigo,
    );
    return await remoteDataSource.updateRepartidor(id, model);
  }

  @override
  Future<void> deleteRepartidor(String id) async {
    await remoteDataSource.deleteRepartidor(id);
  }
}
