import '../../../../core/config/api_config.dart';
import '../../../../core/network/api_client.dart';
import '../../../pedidos/data/models/pedido_model.dart';
import '../models/repartidor_model.dart';
import 'repartidor_remote_data_source.dart';

class RepartidorRemoteDataSourceImpl implements RepartidorRemoteDataSource {
  RepartidorRemoteDataSourceImpl({required this.apiClient});

  final ApiClient apiClient;

  // CRUD Repartidores
  Future<List<RepartidorModel>> getRepartidores() async {
    final response = await apiClient.get(ApiConfig.repartidoresPath);
    if (response is! List) return const [];
    return response
        .whereType<Map<String, dynamic>>()
        .map(RepartidorModel.fromJson)
        .toList();
  }

  @override
  Future<RepartidorModel> getRepartidorInfo(String id) async {
    final response = await apiClient.get('${ApiConfig.repartidoresPath}/$id');
    return RepartidorModel.fromJson(response as Map<String, dynamic>);
  }

  Future<RepartidorModel> createRepartidor(RepartidorModel repartidor) async {
    final response = await apiClient.post(
      ApiConfig.repartidoresPath,
      body: repartidor.toJson(),
    );
    return RepartidorModel.fromJson(response as Map<String, dynamic>);
  }

  Future<RepartidorModel> updateRepartidor(String id, RepartidorModel repartidor) async {
    final response = await apiClient.put(
      '${ApiConfig.repartidoresPath}/$id',
      body: repartidor.toJson(),
    );
    return RepartidorModel.fromJson(response as Map<String, dynamic>);
  }

  Future<void> deleteRepartidor(String id) async {
    await apiClient.delete('${ApiConfig.repartidoresPath}/$id');
  }

  // Funciones de pedidos para repartidor
  @override
  Future<List<PedidoModel>> getPedidosAsignados(String repartidorId) async {
    final response = await apiClient.get('${ApiConfig.pedidosPath}/repartidor/mis-pedidos');
    if (response is! List) return const [];
    return response
        .whereType<Map<String, dynamic>>()
        .map(PedidoModel.fromJson)
        .toList();
  }

  @override
  Future<void> actualizarEstadoPedido(String pedidoId, String nuevoEstado) async {
    await apiClient.put('${ApiConfig.pedidosPath}/$pedidoId/estado/$nuevoEstado');
  }

  @override
  Future<void> iniciarTurno(String repartidorId) async {
    // Implementar si el backend lo soporta
  }

  @override
  Future<void> finalizarTurno(String repartidorId) async {
    // Implementar si el backend lo soporta
  }

  // Acciones específicas de repartidor
  Future<void> iniciarEntrega(String pedidoId) async {
    await apiClient.put('${ApiConfig.pedidosPath}/$pedidoId/iniciar-entrega');
  }

  Future<void> marcarEntregado(String pedidoId) async {
    await apiClient.put('${ApiConfig.pedidosPath}/$pedidoId/entregado');
  }
}
