import '../../domain/entities/pedido.dart';
import 'pedido_remote_data_source.dart';

class PedidoMockDataSource implements PedidoRemoteDataSource {
  @override
  Future<List<Pedido>> getPedidos() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    
    return [
      Pedido(
        id: 'XXXXXX',
        nombreUsuario: 'Darely M. Quispe Condori',
        apodo: 'Daryn',
        costoTotal: 1000.00,
        fechaPedido: DateTime.now().subtract(const Duration(hours: 2)),
        fechaEntrega: DateTime.now().add(const Duration(days: 1)),
        repartidor: 'David Hoyos',
        direccion: 'Lima - Miraflores - Mz8B',
        estado: 'Enviado',
      ),
      Pedido(
        id: '879',
        nombreUsuario: 'María García',
        apodo: 'Mary',
        costoTotal: 32.00,
        fechaPedido: DateTime.now().subtract(const Duration(hours: 1)),
        fechaEntrega: DateTime.now().add(const Duration(hours: 2)),
        repartidor: 'Luis Martínez',
        direccion: 'Calle Los Olivos 456, Lima',
        estado: 'En camino',
      ),
      Pedido(
        id: '456',
        nombreUsuario: 'Carlos Rodríguez',
        apodo: 'Carlitos',
        costoTotal: 75.50,
        fechaPedido: DateTime.now().subtract(const Duration(days: 1)),
        fechaEntrega: DateTime.now().subtract(const Duration(hours: 2)),
        repartidor: 'David Hoyos',
        direccion: 'Av. Principal 789, Lima',
        estado: 'Entregado',
      ),
      Pedido(
        id: '123',
        nombreUsuario: 'Ana López',
        apodo: 'Anita',
        costoTotal: 45.00,
        fechaPedido: DateTime.now().subtract(const Duration(days: 2)),
        fechaEntrega: DateTime.now().subtract(const Duration(days: 1)),
        repartidor: 'David Hoyos',
        direccion: 'Jr. Los Girasoles 321, Lima',
        estado: 'Entregado',
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
