class User {
  final int idUsuario;
  final String username;
  final String profileFotoUrl;
  final List<String> roles;
  final String accessToken;
  final String refreshToken;

  User({
    required this.idUsuario,
    required this.username,
    required this.profileFotoUrl,
    required this.roles,
    required this.accessToken,
    required this.refreshToken,
  });
}
