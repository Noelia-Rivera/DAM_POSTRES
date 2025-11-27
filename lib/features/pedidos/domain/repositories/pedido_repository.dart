import '../entities/pedido.dart';

abstract class PedidoRepository {
  // CRUD básico
  Future<List<Pedido>> getPedidos();
  Future<Pedido> getPedidoById(String id);
  Future<Pedido> getPedidoDetalle(String id);
  Future<Pedido> createPedidoCliente(Pedido pedido, List<Map<String, dynamic>> detalles);
  Future<Pedido> createPedidoAdmin(Pedido pedido, List<Map<String, dynamic>> detalles);
  Future<Pedido> updatePedido(String id, Pedido pedido, List<Map<String, dynamic>> detalles);
  Future<void> deletePedido(String id);
  
  // Mis pedidos
  Future<List<Pedido>> getMisPedidosCliente();
  Future<List<Pedido>> getMisPedidosRepartidor();
  
  // Acciones de estado (ADMIN)
  Future<void> aceptarPedido(String id);
  Future<void> marcarEnPreparacion(String id);
  Future<void> marcarListoParaEntrega(String id);
  Future<void> asignarRepartidor(String pedidoId, String repartidorId);
  Future<void> cancelarPedido(String id);
  
  // Acciones de estado (REPARTIDOR)
  Future<void> iniciarEntrega(String id);
  Future<void> marcarEntregado(String id);
  Future<void> actualizarEstado(String pedidoId, String estadoId);
  
  // Detalles
  Future<void> agregarDetalles(String pedidoId, List<Map<String, dynamic>> detalles);
}
