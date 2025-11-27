import '../../domain/entities/repartidor.dart';
import '../../domain/repositories/repartidor_repository.dart';
import '../../../pedidos/domain/entities/pedido.dart';
import '../datasources/repartidor_remote_data_source.dart';

class RepartidorRepositoryImpl implements RepartidorRepository {
  final RepartidorRemoteDataSource remoteDataSource;

  RepartidorRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Repartidor> getRepartidorInfo(String id) async {
    return await remoteDataSource.getRepartidorInfo(id);
  }

  @override
  Future<List<Pedido>> getPedidosAsignados(String repartidorId) async {
    return await remoteDataSource.getPedidosAsignados(repartidorId);
  }

  @override
  Future<void> actualizarEstadoPedido(String pedidoId, String nuevoEstado) async {
    await remoteDataSource.actualizarEstadoPedido(pedidoId, nuevoEstado);
  }

  @override
  Future<void> iniciarTurno(String repartidorId) async {
    await remoteDataSource.iniciarTurno(repartidorId);
  }

  @override
  Future<void> finalizarTurno(String repartidorId) async {
    await remoteDataSource.finalizarTurno(repartidorId);
  }
}

