import '../../domain/entities/pedido.dart';

abstract class PedidoRemoteDataSource {
  Future<List<Pedido>> getPedidos();
  Future<void> createPedido(Pedido pedido);
  Future<void> updatePedido(Pedido pedido);
  Future<void> deletePedido(String id);
}
