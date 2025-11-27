import '../../domain/entities/repartidor.dart';
import '../../../pedidos/domain/entities/pedido.dart';
import 'repartidor_remote_data_source.dart';

class RepartidorMockDataSource implements RepartidorRemoteDataSource {
  @override
  Future<Repartidor> getRepartidorInfo(String id) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    return Repartidor(
      id: id,
      nombre: 'David',
      apellido: 'Hoyos',
      email: 'david.hoyos@example.com',
      telefono: '987654321',
      enTurno: false,
      pedidosEntregadosHoy: 3,
      gananciasDelDia: 56.00,
    );
  }

  @override
  Future<List<Pedido>> getPedidosAsignados(String repartidorId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Retornar pedidos asignados a este repartidor
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
        repartidor: 'David Hoyos',
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
  Future<void> actualizarEstadoPedido(String pedidoId, String nuevoEstado) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // En una implementación real, aquí se haría la llamada al API
  }

  @override
  Future<void> iniciarTurno(String repartidorId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // En una implementación real, aquí se haría la llamada al API
  }

  @override
  Future<void> finalizarTurno(String repartidorId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // En una implementación real, aquí se haría la llamada al API
  }
}

