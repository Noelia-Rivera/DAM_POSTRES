class Persona {
  final String id;
  final String nombres;
  final String apellidos;
  final String dni;
  final String correo;
  final String telefono;
  final String direccion;

  const Persona({
    required this.id,
    required this.nombres,
    required this.apellidos,
    required this.dni,
    required this.correo,
    required this.telefono,
    required this.direccion,
  });

  String get nombreCompleto => '$nombres $apellidos';
}
