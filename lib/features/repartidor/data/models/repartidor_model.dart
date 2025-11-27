import '../../domain/entities/repartidor.dart';

class RepartidorModel extends Repartidor {
  RepartidorModel({
    required super.id,
    required super.nombre,
    required super.apellido,
    required super.email,
    required super.telefono,
    super.enTurno,
    super.pedidosEntregadosHoy,
    super.gananciasDelDia,
    this.codigo,
  });

  final String? codigo;

  factory RepartidorModel.fromJson(Map<String, dynamic> json) {
    final personaJson = json['persona'] as Map<String, dynamic>?;
    final usuarioJson = json['usuario'] as Map<String, dynamic>?;
    
    return RepartidorModel(
      id: (json['idRepartidor'] ?? json['id'])?.toString() ?? '',
      codigo: json['codigo'] as String?,
      nombre: personaJson?['nombres'] as String? ?? usuarioJson?['username'] as String? ?? '',
      apellido: personaJson?['apellidos'] as String? ?? '',
      email: personaJson?['correo'] as String? ?? '',
      telefono: personaJson?['telefono'] as String? ?? '',
      enTurno: json['enTurno'] as bool? ?? false,
      pedidosEntregadosHoy: json['pedidosEntregadosHoy'] as int? ?? 0,
      gananciasDelDia: (json['gananciasDelDia'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => {
    'codigo': codigo,
  };

  factory RepartidorModel.fromEntity(Repartidor repartidor, {String? codigo}) {
    return RepartidorModel(
      id: repartidor.id,
      nombre: repartidor.nombre,
      apellido: repartidor.apellido,
      email: repartidor.email,
      telefono: repartidor.telefono,
      enTurno: repartidor.enTurno,
      pedidosEntregadosHoy: repartidor.pedidosEntregadosHoy,
      gananciasDelDia: repartidor.gananciasDelDia,
      codigo: codigo,
    );
  }
}
