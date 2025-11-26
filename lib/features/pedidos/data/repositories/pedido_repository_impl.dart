import '../../domain/entities/pedido.dart';
import '../../domain/repositories/pedido_repository.dart';
import '../datasources/pedido_remote_data_source.dart';

class PedidoRepositoryImpl implements PedidoRepository {
  final PedidoRemoteDataSource remoteDataSource;

  PedidoRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Pedido>> getPedidos() async {
    return await remoteDataSource.getPedidos();
  }

  @override
  Future<void> createPedido(Pedido pedido) async {
    await remoteDataSource.createPedido(pedido);
  }

  @override
  Future<void> updatePedido(Pedido pedido) async {
    await remoteDataSource.updatePedido(pedido);
  }

  @override
  Future<void> deletePedido(String id) async {
    await remoteDataSource.deletePedido(id);
  }
}
