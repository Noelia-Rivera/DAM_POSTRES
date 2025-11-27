import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/services/auth_service.dart';
import '../../../auth/domain/entities/user.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? _user;
  bool _isLoading = true;
  String _userRole = '';

  final _nombresController = TextEditingController();
  final _apellidosController = TextEditingController();
  final _direccionController = TextEditingController();
  final _dniController = TextEditingController();
  final _telefonoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _nombresController.dispose();
    _apellidosController.dispose();
    _direccionController.dispose();
    _dniController.dispose();
    _telefonoController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    final authService = AuthService();
    final user = await authService.getUser();
    final role = await authService.getPrimaryRole();
    
    if (mounted) {
      setState(() {
        _user = user;
        _userRole = role ?? 'CLIENTE';
        _isLoading = false;
      });
    }
  }

  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cerrar Sesión'),
        content: const Text('¿Estás seguro de que deseas cerrar sesión?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Cerrar Sesión', style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirm == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      if (mounted) context.go('/');
    }
  }

  String _getRoleLabel() {
    switch (_userRole) {
      case 'ADMIN': return 'Administrador';
      case 'REPARTIDOR': return 'Repartidor';
      default: return 'Cliente';
    }
  }

  String _getHomeRoute() {
    switch (_userRole) {
      case 'ADMIN': return '/admin';
      case 'REPARTIDOR': return '/repartidor';
      default: return '/cliente';
    }
  }

  @override
  Widget build(BuildContext context) {
    final pinkColor = const Color(0xFFD7B3AF);
    final beigeColor = const Color(0xFFE8DAB6);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: pinkColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.go(_getHomeRoute()),
        ),
        title: const Text('Mi perfil', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20)),
        centerTitle: false,
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: _logout,
            tooltip: 'Cerrar Sesión',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  // Avatar
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: _user?.profileFotoUrl != null && _user!.profileFotoUrl.isNotEmpty
                            ? NetworkImage(_user!.profileFotoUrl)
                            : const NetworkImage('https://cdn-icons-png.flaticon.com/512/706/706830.png'),
                        backgroundColor: Colors.white,
                      ),
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(color: pinkColor, width: 2),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.camera_alt, size: 16),
                          color: pinkColor,
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Función de cambiar foto próximamente')),
                            );
                          },
                          padding: EdgeInsets.zero,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Username
                  Text(
                    _user?.username.toUpperCase() ?? 'USUARIO',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
                  ),
                  // Rol
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: pinkColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(_getRoleLabel(), style: TextStyle(color: pinkColor, fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(height: 8),
                  Text('ID: ${_user?.idUsuario ?? '-'}', style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 30),
                  // Información del usuario
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [BoxShadow(color: Colors.black12.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 3))],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Información de cuenta', style: TextStyle(color: pinkColor, fontWeight: FontWeight.bold, fontSize: 16)),
                              Icon(Icons.info_outline, color: pinkColor),
                            ],
                          ),
                          const SizedBox(height: 20),
                          _InfoField(icon: Icons.person, label: 'Usuario', value: _user?.username ?? '-'),
                          const SizedBox(height: 16),
                          _InfoField(icon: Icons.badge, label: 'ID Usuario', value: '${_user?.idUsuario ?? '-'}'),
                          const SizedBox(height: 16),
                          _InfoField(icon: Icons.security, label: 'Rol', value: _getRoleLabel()),
                          const SizedBox(height: 16),
                          _InfoField(
                            icon: Icons.verified_user,
                            label: 'Roles asignados',
                            value: _user?.roles.join(', ') ?? '-',
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Botón de cerrar sesión
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade400,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: _logout,
                      icon: const Icon(Icons.logout),
                      label: const Text('Cerrar Sesión', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    final pinkColor = const Color(0xFFD7B3AF);
    
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: pinkColor,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white70,
      showUnselectedLabels: true,
      currentIndex: 2,
      onTap: (index) {
        if (index == 0) context.go(_getHomeRoute());
        if (index == 1) {
          switch (_userRole) {
            case 'ADMIN': context.push('/admin/pedidos'); break;
            case 'REPARTIDOR': context.go('/repartidor/pedidos'); break;
            default: context.push('/cliente/mis-pedidos'); break;
          }
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
        BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'Pedidos'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
      ],
    );
  }
}

class _InfoField extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoField({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final pinkColor = const Color(0xFFD7B3AF);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F1F1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: pinkColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: pinkColor, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
