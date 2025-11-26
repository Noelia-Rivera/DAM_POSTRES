class Pedido {
  final String id;
  final String nombreUsuario;
  final String apodo;
  final double costoTotal;
  final DateTime fechaPedido;
  final DateTime fechaEntrega;
  final String repartidor;
  final String direccion;
  final String estado;

  Pedido({
    required this.id,
    required this.nombreUsuario,
    required this.apodo,
    required this.costoTotal,
    required this.fechaPedido,
    required this.fechaEntrega,
    required this.repartidor,
    required this.direccion,
    this.estado = 'Pendiente',
  });
}
