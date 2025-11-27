import '../../../pedidos/domain/entities/pedido.dart';
import '../repositories/repartidor_repository.dart';

class GetPedidosAsignadosUseCase {
  final RepartidorRepository repository;

  GetPedidosAsignadosUseCase(this.repository);

  Future<List<Pedido>> call(String repartidorId) async {
    return await repository.getPedidosAsignados(repartidorId);
  }
}

