import '../../domain/entities/rol.dart';
import '../../domain/repositories/rol_repository.dart';
import '../datasources/rol_remote_data_source.dart';
import '../models/rol_model.dart';

class RolRepositoryImpl implements RolRepository {
  final RolRemoteDataSource remoteDataSource;

  RolRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Rol>> getRoles() async {
    return await remoteDataSource.getRoles();
  }

  @override
  Future<Rol> getRolById(String id) async {
    return await remoteDataSource.getRolById(id);
  }

  @override
  Future<Rol> createRol(Rol rol) async {
    final model = RolModel.fromEntity(rol);
    return await remoteDataSource.createRol(model);
  }

  @override
  Future<Rol> updateRol(String id, Rol rol) async {
    final model = RolModel.fromEntity(rol);
    return await remoteDataSource.updateRol(id, model);
  }

  @override
  Future<void> deleteRol(String id) async {
    await remoteDataSource.deleteRol(id);
  }
}
