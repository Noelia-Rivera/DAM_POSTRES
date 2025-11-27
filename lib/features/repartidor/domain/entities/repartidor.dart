class Repartidor {
  final String id;
  final String nombre;
  final String apellido;
  final String email;
  final String telefono;
  final bool enTurno;
  final int pedidosEntregadosHoy;
  final double gananciasDelDia;

  Repartidor({
    required this.id,
    required this.nombre,
    required this.apellido,
    required this.email,
    required this.telefono,
    this.enTurno = false,
    this.pedidosEntregadosHoy = 0,
    this.gananciasDelDia = 0.0,
  });

  String get nombreCompleto => '$nombre $apellido';
}

