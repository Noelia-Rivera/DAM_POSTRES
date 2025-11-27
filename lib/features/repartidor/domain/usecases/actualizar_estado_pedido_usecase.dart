import '../repositories/repartidor_repository.dart';

class ActualizarEstadoPedidoUseCase {
  final RepartidorRepository repository;

  ActualizarEstadoPedidoUseCase(this.repository);

  Future<void> call(String pedidoId, String nuevoEstado) async {
    return await repository.actualizarEstadoPedido(pedidoId, nuevoEstado);
  }
}

