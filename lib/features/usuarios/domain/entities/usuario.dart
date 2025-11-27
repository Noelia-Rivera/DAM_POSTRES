class Usuario {
  final String id;
  final String username;
  final String? profileFotoUrl;
  final List<String> roles;
  final String? idPersona;
  final String? idRepartidor;

  const Usuario({
    required this.id,
    required this.username,
    this.profileFotoUrl,
    this.roles = const [],
    this.idPersona,
    this.idRepartidor,
  });
}
