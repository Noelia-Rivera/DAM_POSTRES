import '../entities/repartidor.dart';
import '../../../pedidos/domain/entities/pedido.dart';

abstract class RepartidorRepository {
  Future<Repartidor> getRepartidorInfo(String id);
  Future<List<Pedido>> getPedidosAsignados(String repartidorId);
  Future<void> actualizarEstadoPedido(String pedidoId, String nuevoEstado);
  Future<void> iniciarTurno(String repartidorId);
  Future<void> finalizarTurno(String repartidorId);
}

