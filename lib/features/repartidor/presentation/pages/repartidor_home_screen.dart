import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/services/api_services.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/services/notification_service.dart';
import '../../../pedidos/data/models/pedido_model.dart';

class RepartidorHomeScreen extends StatefulWidget {
  const RepartidorHomeScreen({super.key});

  @override
  State<RepartidorHomeScreen> createState() => _RepartidorHomeScreenState();
}

class _RepartidorHomeScreenState extends State<RepartidorHomeScreen> {
  List<PedidoModel> _pedidosPendientes = [];
  bool _isLoading = true;
  int _pedidosHoy = 0;
  String _username = 'Repartidor';
  
  final NotificationService _notificationService = NotificationService();
  StreamSubscription<NotificacionPedido>? _notificacionSubscription;

  @override
  void initState() {
    super.initState();
    _loadData();
    _loadUsername();
    _iniciarNotificaciones();
  }

  void _iniciarNotificaciones() {
    _notificationService.iniciar();
    _notificacionSubscription = _notificationService.notificacionStream.listen((notificacion) {
      if (mounted) {
        NotificationService.mostrarNotificacion(context, notificacion);
        // Recargar pedidos si se asignó uno nuevo
        if (notificacion.tipo == 'PEDIDO_ASIGNADO') {
          _loadData();
        }
      }
    });
  }

  @override
  void dispose() {
    _notificacionSubscription?.cancel();
    _notificationService.detener();
    super.dispose();
  }

  Future<void> _loadUsername() async {
    final authService = AuthService();
    final user = await authService.getUser();
    if (user != null && mounted) {
      setState(() => _username = user.username);
    }
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final pedidos = await ApiServices.pedidoDataSource.getMisPedidosRepartidor();
      if (mounted) {
        setState(() {
          _pedidosPendientes = pedidos.where((p) => 
            p.estado.toUpperCase() != 'ENTREGADO' && 
            p.estado.toUpperCase() != 'CANCELADO'
          ).toList();
          _pedidosHoy = pedidos.where((p) => 
            p.estado.toUpperCase() == 'ENTREGADO' &&
            p.fechaEntrega.day == DateTime.now().day
          ).length;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final pinkColor = const Color(0xFFD7B3AF);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: pinkColor,
        elevation: 0,
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
        title: const Text('Repartidor', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      drawer: _RepartidorDrawer(),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Hola, $_username', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('Tienes ${_pedidosPendientes.length} pedidos pendientes', style: TextStyle(color: Colors.grey[600], fontSize: 16)),
              const SizedBox(height: 24),
              // Stats
              Row(
                children: [
                  Expanded(child: _StatCard(title: 'Pendientes', value: '${_pedidosPendientes.length}', icon: Icons.pending_actions, color: Colors.orange)),
                  const SizedBox(width: 16),
                  Expanded(child: _StatCard(title: 'Entregados Hoy', value: '$_pedidosHoy', icon: Icons.check_circle, color: Colors.green)),
                ],
              ),
              const SizedBox(height: 24),
              // Pedidos pendientes
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Pedidos Pendientes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  TextButton(
                    onPressed: () => context.go('/repartidor/pedidos'),
                    child: Text('Ver todos', style: TextStyle(color: pinkColor)),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else if (_pedidosPendientes.isEmpty)
                Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
                  child: const Center(
                    child: Column(children: [
                      Icon(Icons.check_circle_outline, size: 48, color: Colors.green),
                      SizedBox(height: 12),
                      Text('¡No tienes pedidos pendientes!', style: TextStyle(color: Colors.grey)),
                    ]),
                  ),
                )
              else
                ..._pedidosPendientes.take(3).map((pedido) => _PedidoMiniCard(pedido: pedido)),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _BottomNavigationBar(),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  const _StatCard({required this.title, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: color)),
          Text(title, style: TextStyle(color: Colors.grey[600])),
        ],
      ),
    );
  }
}

class _PedidoMiniCard extends StatelessWidget {
  final PedidoModel pedido;
  const _PedidoMiniCard({required this.pedido});

  @override
  Widget build(BuildContext context) {
    final pinkColor = const Color(0xFFD7B3AF);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: pinkColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: pinkColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: pinkColor, borderRadius: BorderRadius.circular(8)),
            child: const Icon(Icons.delivery_dining, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Pedido #${pedido.id}', style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(pedido.direccion, style: TextStyle(color: Colors.grey[600], fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
            ]),
          ),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text('S/. ${pedido.costoTotal.toStringAsFixed(0)}', style: TextStyle(fontWeight: FontWeight.bold, color: pinkColor)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(10)),
              child: Text(pedido.estado.replaceAll('_', ' '), style: const TextStyle(color: Colors.white, fontSize: 10)),
            ),
          ]),
        ],
      ),
    );
  }
}

class _RepartidorDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final pinkColor = const Color(0xFFD7B3AF);
    return Drawer(
      backgroundColor: pinkColor,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(24),
              child: Text('POSTRECITOS', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
            ),
            ListTile(
              leading: const Icon(Icons.home, color: Colors.white),
              title: const Text('Inicio', style: TextStyle(color: Colors.white)),
              onTap: () { Navigator.pop(context); },
            ),
            ListTile(
              leading: const Icon(Icons.delivery_dining, color: Colors.white),
              title: const Text('Mis Pedidos', style: TextStyle(color: Colors.white)),
              onTap: () { Navigator.pop(context); context.go('/repartidor/pedidos'); },
            ),
            ListTile(
              leading: const Icon(Icons.person, color: Colors.white),
              title: const Text('Mi Perfil', style: TextStyle(color: Colors.white)),
              onTap: () { Navigator.pop(context); context.go('/profile'); },
            ),
            const Spacer(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.white),
              title: const Text('Cerrar Sesión', style: TextStyle(color: Colors.white)),
              onTap: () async {
                Navigator.pop(context);
                final prefs = await SharedPreferences.getInstance();
                await prefs.clear();
                if (context.mounted) context.go('/');
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _BottomNavigationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final pinkColor = const Color(0xFFD7B3AF);
    return Container(
      decoration: BoxDecoration(color: pinkColor),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(icon: Icons.home, label: 'Home', isSelected: true, onTap: () {}),
              _NavItem(icon: Icons.delivery_dining, label: 'Pedidos', onTap: () => context.go('/repartidor/pedidos')),
              _NavItem(icon: Icons.person_outline, label: 'Perfil', onTap: () => context.go('/profile')),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  const _NavItem({required this.icon, required this.label, this.isSelected = false, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 24),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}
