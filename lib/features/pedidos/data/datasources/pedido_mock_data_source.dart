import '../../domain/entities/pedido.dart';
import 'pedido_remote_data_source.dart';

class PedidoMockDataSource implements PedidoRemoteDataSource {
  @override
  Future<List<Pedido>> getPedidos() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    
    return [
      Pedido(
        id: '1',
        nombreUsuario: 'Juan Pérez',
        apodo: 'Juanito',
        costoTotal: 45.50,
        fechaPedido: DateTime.now().subtract(const Duration(hours: 2)),
        fechaEntrega: DateTime.now().add(const Duration(hours: 1)),
        repartidor: 'Carlos Rodríguez',
        direccion: 'Av. Principal 123, Lima',
        estado: 'En camino',
      ),
      Pedido(
        id: '2',
        nombreUsuario: 'María García',
        apodo: 'Mary',
        costoTotal: 32.00,
        fechaPedido: DateTime.now().subtract(const Duration(hours: 1)),
        fechaEntrega: DateTime.now().add(const Duration(hours: 2)),
        repartidor: 'Luis Martínez',
        direccion: 'Calle Los Olivos 456, Lima',
        estado: 'Pendiente',
      ),
    ];
  }

  @override
  Future<void> createPedido(Pedido pedido) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<void> updatePedido(Pedido pedido) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<void> deletePedido(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
