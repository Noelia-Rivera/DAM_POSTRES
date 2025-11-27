import '../../domain/entities/persona.dart';

class PersonaModel extends Persona {
  const PersonaModel({
    required super.id,
    required super.nombres,
    required super.apellidos,
    required super.dni,
    required super.correo,
    required super.telefono,
    required super.direccion,
  });

  factory PersonaModel.fromJson(Map<String, dynamic> json) {
    return PersonaModel(
      id: (json['idPersona'] ?? json['id'])?.toString() ?? '',
      nombres: json['nombres'] as String? ?? '',
      apellidos: json['apellidos'] as String? ?? '',
      dni: json['dni'] as String? ?? '',
      correo: json['correo'] as String? ?? '',
      telefono: json['telefono'] as String? ?? '',
      direccion: json['direccion'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'nombres': nombres,
    'apellidos': apellidos,
    'dni': dni,
    'correo': correo,
    'telefono': telefono,
    'direccion': direccion,
  };

  factory PersonaModel.fromEntity(Persona persona) {
    return PersonaModel(
      id: persona.id,
      nombres: persona.nombres,
      apellidos: persona.apellidos,
      dni: persona.dni,
      correo: persona.correo,
      telefono: persona.telefono,
      direccion: persona.direccion,
    );
  }
}
