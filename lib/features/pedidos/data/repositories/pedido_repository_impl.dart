import '../../domain/entities/pedido.dart';
import '../../domain/repositories/pedido_repository.dart';
import '../datasources/pedido_remote_data_source_impl.dart';
import '../models/pedido_model.dart';

class PedidoRepositoryImpl implements PedidoRepository {
  final PedidoRemoteDataSourceImpl remoteDataSource;

  PedidoRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Pedido>> getPedidos() async {
    return await remoteDataSource.getPedidos();
  }

  @override
  Future<Pedido> getPedidoById(String id) async {
    return await remoteDataSource.getPedidoById(id);
  }

  @override
  Future<Pedido> getPedidoDetalle(String id) async {
    return await remoteDataSource.getPedidoDetalle(id);
  }

  @override
  Future<Pedido> createPedidoCliente(Pedido pedido, List<Map<String, dynamic>> detalles) async {
    final model = _createPedidoModel(pedido, detalles);
    return await remoteDataSource.createPedidoCliente(model);
  }

  @override
  Future<Pedido> createPedidoAdmin(Pedido pedido, List<Map<String, dynamic>> detalles) async {
    final model = _createPedidoModel(pedido, detalles);
    return await remoteDataSource.createPedidoAdmin(model);
  }

  @override
  Future<Pedido> updatePedido(String id, Pedido pedido, List<Map<String, dynamic>> detalles) async {
    final model = _createPedidoModel(pedido, detalles);
    return await remoteDataSource.updatePedido(id, model);
  }

  @override
  Future<void> deletePedido(String id) async {
    await remoteDataSource.deletePedido(id);
  }

  @override
  Future<List<Pedido>> getMisPedidosCliente() async {
    return await remoteDataSource.getMisPedidosCliente();
  }

  @override
  Future<List<Pedido>> getMisPedidosRepartidor() async {
    return await remoteDataSource.getMisPedidosRepartidor();
  }

  @override
  Future<void> aceptarPedido(String id) async {
    await remoteDataSource.aceptarPedido(id);
  }

  @override
  Future<void> marcarEnPreparacion(String id) async {
    await remoteDataSource.marcarEnPreparacion(id);
  }

  @override
  Future<void> marcarListoParaEntrega(String id) async {
    await remoteDataSource.marcarListoParaEntrega(id);
  }

  @override
  Future<void> asignarRepartidor(String pedidoId, String repartidorId) async {
    await remoteDataSource.asignarRepartidor(pedidoId, repartidorId);
  }

  @override
  Future<void> cancelarPedido(String id) async {
    await remoteDataSource.cancelarPedido(id);
  }

  @override
  Future<void> iniciarEntrega(String id) async {
    await remoteDataSource.iniciarEntrega(id);
  }

  @override
  Future<void> marcarEntregado(String id) async {
    await remoteDataSource.marcarEntregado(id);
  }

  @override
  Future<void> actualizarEstado(String pedidoId, String estadoId) async {
    await remoteDataSource.actualizarEstado(pedidoId, estadoId);
  }

  @override
  Future<void> agregarDetalles(String pedidoId, List<Map<String, dynamic>> detalles) async {
    final detallesModel = detalles.map((d) => DetallePedidoModel(
      idProducto: d['idProducto'] as int,
      cantidad: d['cantidad'] as int,
    )).toList();
    await remoteDataSource.agregarDetalles(pedidoId, detallesModel);
  }

  PedidoModel _createPedidoModel(Pedido pedido, List<Map<String, dynamic>> detalles) {
    return PedidoModel(
      id: pedido.id,
      nombreUsuario: pedido.nombreUsuario,
      apodo: pedido.apodo,
      costoTotal: pedido.costoTotal,
      fechaPedido: pedido.fechaPedido,
      fechaEntrega: pedido.fechaEntrega,
      repartidor: pedido.repartidor,
      direccion: pedido.direccion,
      estado: pedido.estado,
      detalles: detalles.map((d) => DetallePedidoModel(
        idProducto: d['idProducto'] as int,
        cantidad: d['cantidad'] as int,
      )).toList(),
    );
  }
}
