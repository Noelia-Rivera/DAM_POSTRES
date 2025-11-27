import '../../../../core/config/api_config.dart';
import '../../../../core/network/api_client.dart';
import '../models/pedido_model.dart';

class PedidoRemoteDataSourceImpl {
  PedidoRemoteDataSourceImpl({required this.apiClient});

  final ApiClient apiClient;

  // Listar todos los pedidos (ADMIN)
  Future<List<PedidoModel>> getPedidos() async {
    final response = await apiClient.get(ApiConfig.pedidosPath);
    if (response is! List) return const [];
    return response
        .whereType<Map<String, dynamic>>()
        .map(PedidoModel.fromJson)
        .toList();
  }

  // Obtener pedido por ID
  Future<PedidoModel> getPedidoById(String id) async {
    final response = await apiClient.get('${ApiConfig.pedidosPath}/$id');
    return PedidoModel.fromJson(response as Map<String, dynamic>);
  }

  // Obtener detalle de pedido
  Future<PedidoModel> getPedidoDetalle(String id) async {
    final response = await apiClient.get('${ApiConfig.pedidosPath}/$id/detalle');
    return PedidoModel.fromJson(response as Map<String, dynamic>);
  }

  // Crear pedido (CLIENTE)
  Future<PedidoModel> createPedidoCliente(PedidoModel pedido) async {
    final response = await apiClient.post(
      '${ApiConfig.pedidosPath}/create',
      body: pedido.toCreateJson(),
    );
    return PedidoModel.fromJson(response as Map<String, dynamic>);
  }

  // Crear pedido (ADMIN)
  Future<PedidoModel> createPedidoAdmin(PedidoModel pedido) async {
    final response = await apiClient.post(
      ApiConfig.pedidosPath,
      body: pedido.toCreateJson(),
    );
    return PedidoModel.fromJson(response as Map<String, dynamic>);
  }

  // Actualizar pedido (ADMIN)
  Future<PedidoModel> updatePedido(String id, PedidoModel pedido) async {
    final response = await apiClient.put(
      '${ApiConfig.pedidosPath}/$id',
      body: pedido.toUpdateJson(),
    );
    return PedidoModel.fromJson(response as Map<String, dynamic>);
  }

  // Eliminar pedido (ADMIN)
  Future<void> deletePedido(String id) async {
    await apiClient.delete('${ApiConfig.pedidosPath}/$id');
  }

  // Mis pedidos (CLIENTE)
  Future<List<PedidoModel>> getMisPedidosCliente() async {
    final response = await apiClient.get('${ApiConfig.pedidosPath}/cliente/mis-pedidos');
    if (response is! List) return const [];
    return response
        .whereType<Map<String, dynamic>>()
        .map(PedidoModel.fromJson)
        .toList();
  }

  // Mis pedidos (REPARTIDOR)
  Future<List<PedidoModel>> getMisPedidosRepartidor() async {
    final response = await apiClient.get('${ApiConfig.pedidosPath}/repartidor/mis-pedidos');
    if (response is! List) return const [];
    return response
        .whereType<Map<String, dynamic>>()
        .map(PedidoModel.fromJson)
        .toList();
  }

  // Aceptar pedido (ADMIN)
  Future<void> aceptarPedido(String id) async {
    await apiClient.put('${ApiConfig.pedidosPath}/$id/aceptar');
  }

  // Marcar en preparación (ADMIN)
  Future<void> marcarEnPreparacion(String id) async {
    await apiClient.put('${ApiConfig.pedidosPath}/$id/en-preparacion');
  }

  // Marcar listo para entrega (ADMIN)
  Future<void> marcarListoParaEntrega(String id) async {
    await apiClient.put('${ApiConfig.pedidosPath}/$id/listo-para-entrega');
  }

  // Asignar repartidor (ADMIN)
  Future<void> asignarRepartidor(String pedidoId, String repartidorId) async {
    await apiClient.put('${ApiConfig.pedidosPath}/$pedidoId/asignar/$repartidorId');
  }

  // Cancelar pedido (ADMIN)
  Future<void> cancelarPedido(String id) async {
    await apiClient.put('${ApiConfig.pedidosPath}/$id/cancelar');
  }

  // Iniciar entrega (REPARTIDOR)
  Future<void> iniciarEntrega(String id) async {
    await apiClient.put('${ApiConfig.pedidosPath}/$id/iniciar-entrega');
  }

  // Marcar entregado (REPARTIDOR)
  Future<void> marcarEntregado(String id) async {
    await apiClient.put('${ApiConfig.pedidosPath}/$id/entregado');
  }

  // Actualizar estado (REPARTIDOR)
  Future<void> actualizarEstado(String pedidoId, String estadoId) async {
    await apiClient.put('${ApiConfig.pedidosPath}/$pedidoId/estado/$estadoId');
  }

  // Agregar detalles (CLIENTE)
  Future<void> agregarDetalles(String pedidoId, List<DetallePedidoModel> detalles) async {
    await apiClient.post(
      '${ApiConfig.pedidosPath}/$pedidoId/detalles/agregar',
      body: detalles.map((d) => d.toJson()).toList(),
    );
  }
}
