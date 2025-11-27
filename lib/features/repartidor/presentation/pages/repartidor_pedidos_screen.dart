import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/services/api_services.dart';
import '../../../pedidos/data/models/pedido_model.dart';

class RepartidorPedidosScreen extends StatefulWidget {
  const RepartidorPedidosScreen({super.key});

  @override
  State<RepartidorPedidosScreen> createState() => _RepartidorPedidosScreenState();
}

class _RepartidorPedidosScreenState extends State<RepartidorPedidosScreen> {
  String _filtroSeleccionado = 'Todos';
  List<PedidoModel> _pedidos = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadPedidos();
  }

  Future<void> _loadPedidos() async {
    setState(() { _isLoading = true; _error = null; });
    try {
      final pedidos = await ApiServices.pedidoDataSource.getMisPedidosRepartidor();
      if (mounted) setState(() { _pedidos = pedidos; _isLoading = false; });
    } catch (e) {
      if (mounted) setState(() { _error = e.toString(); _isLoading = false; });
    }
  }

  List<PedidoModel> get _pedidosFiltrados {
    switch (_filtroSeleccionado) {
      case 'Pendientes':
        return _pedidos.where((p) => 
          p.estado.toUpperCase() == 'LISTO_PARA_ENTREGA' || 
          p.estado.toUpperCase() == 'ASIGNADO'
        ).toList();
      case 'En Camino':
        return _pedidos.where((p) => p.estado.toUpperCase() == 'EN_CAMINO').toList();
      case 'Entregados':
        return _pedidos.where((p) => p.estado.toUpperCase() == 'ENTREGADO').toList();
      default:
        return _pedidos;
    }
  }

  Color _getEstadoColor(String estado) {
    switch (estado.toUpperCase()) {
      case 'LISTO_PARA_ENTREGA': return Colors.teal;
      case 'ASIGNADO': return Colors.blue;
      case 'EN_CAMINO': return Colors.indigo;
      case 'ENTREGADO': return Colors.green;
      default: return Colors.grey;
    }
  }

  Future<void> _iniciarEntrega(PedidoModel pedido) async {
    try {
      await ApiServices.pedidoDataSource.iniciarEntrega(pedido.id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Entrega iniciada'), backgroundColor: Colors.green),
      );
      _loadPedidos();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> _marcarEntregado(PedidoModel pedido) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar Entrega'),
        content: const Text('¿Confirmar que el pedido fue entregado?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Confirmar', style: TextStyle(color: Colors.green))),
        ],
      ),
    );
    if (confirm != true) return;

    try {
      await ApiServices.pedidoDataSource.marcarEntregado(pedido.id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('¡Pedido entregado!'), backgroundColor: Colors.green),
      );
      _loadPedidos();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
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
        title: const Text('Mis Pedidos', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(icon: const Icon(Icons.refresh, color: Colors.white), onPressed: _loadPedidos),
        ],
      ),
      drawer: _RepartidorDrawer(),
      body: Column(
        children: [
          // Filtros
          Container(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['Todos', 'Pendientes', 'En Camino', 'Entregados'].map((filtro) => 
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _FiltroChip(
                      label: filtro,
                      isSelected: _filtroSeleccionado == filtro,
                      onTap: () => setState(() => _filtroSeleccionado = filtro),
                    ),
                  ),
                ).toList(),
              ),
            ),
          ),
          // Lista de pedidos
          Expanded(child: _buildContent()),
        ],
      ),
      bottomNavigationBar: _BottomNavigationBar(),
    );
  }

  Widget _buildContent() {
    if (_isLoading) return const Center(child: CircularProgressIndicator());
    if (_error != null) {
      return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text('Error: $_error', style: const TextStyle(color: Colors.red)),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: _loadPedidos, child: const Text('Reintentar')),
        ]),
      );
    }
    if (_pedidosFiltrados.isEmpty) {
      return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.delivery_dining, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text('No hay pedidos', style: TextStyle(fontSize: 18, color: Colors.grey[600])),
        ]),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadPedidos,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _pedidosFiltrados.length,
        itemBuilder: (context, index) {
          final pedido = _pedidosFiltrados[index];
          return _PedidoCard(
            pedido: pedido,
            estadoColor: _getEstadoColor(pedido.estado),
            onIniciarEntrega: () => _iniciarEntrega(pedido),
            onMarcarEntregado: () => _marcarEntregado(pedido),
            onVerDetalle: () => context.push('/repartidor/pedidos/detalle', extra: pedido),
          );
        },
      ),
    );
  }
}

class _FiltroChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  const _FiltroChip({required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final pinkColor = const Color(0xFFD7B3AF);
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? pinkColor : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: pinkColor),
        ),
        child: Text(label, style: TextStyle(color: isSelected ? Colors.white : Colors.black87, fontWeight: FontWeight.w500)),
      ),
    );
  }
}


class _PedidoCard extends StatelessWidget {
  final PedidoModel pedido;
  final Color estadoColor;
  final VoidCallback onIniciarEntrega;
  final VoidCallback onMarcarEntregado;
  final VoidCallback onVerDetalle;

  const _PedidoCard({
    required this.pedido,
    required this.estadoColor,
    required this.onIniciarEntrega,
    required this.onMarcarEntregado,
    required this.onVerDetalle,
  });

  String _formatDate(DateTime date) => '${date.day}/${date.month}/${date.year}';

  @override
  Widget build(BuildContext context) {
    final pinkColor = const Color(0xFFD7B3AF);
    final estado = pedido.estado.toUpperCase();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: pinkColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Pedido #${pedido.id}', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(color: estadoColor, borderRadius: BorderRadius.circular(20)),
                      child: Text(pedido.estado.replaceAll('_', ' '), style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        const Text('Cliente', style: TextStyle(color: Colors.white70, fontSize: 12)),
                        Text(pedido.nombreUsuario, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                      ]),
                    ),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        const Text('Total', style: TextStyle(color: Colors.white70, fontSize: 12)),
                        Text('S/. ${pedido.costoTotal.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ]),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        const Text('Fecha Entrega', style: TextStyle(color: Colors.white70, fontSize: 12)),
                        Text('${_formatDate(pedido.fechaEntrega)} ${pedido.horaEntrega ?? ''}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                      ]),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.white70, size: 16),
                    const SizedBox(width: 4),
                    Expanded(child: Text(pedido.direccion, style: const TextStyle(color: Colors.white), maxLines: 2, overflow: TextOverflow.ellipsis)),
                  ],
                ),
              ],
            ),
          ),
          // Acciones
          if (estado != 'ENTREGADO')
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
              ),
              child: Row(
                children: [
                  if (estado == 'LISTO_PARA_ENTREGA' || estado == 'ASIGNADO')
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: onIniciarEntrega,
                        icon: const Icon(Icons.delivery_dining, size: 18),
                        label: const Text('Iniciar Entrega'),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo, foregroundColor: Colors.white),
                      ),
                    ),
                  if (estado == 'EN_CAMINO') ...[
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: onMarcarEntregado,
                        icon: const Icon(Icons.check_circle, size: 18),
                        label: const Text('Entregado'),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: onVerDetalle,
                      icon: const Icon(Icons.map, color: Colors.white),
                      tooltip: 'Ver Ruta',
                    ),
                  ],
                ],
              ),
            ),
          if (estado == 'ENTREGADO')
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.3),
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle, color: Colors.white),
                  SizedBox(width: 8),
                  Text('Entregado', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
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
              onTap: () { Navigator.pop(context); context.go('/repartidor'); },
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
              _NavItem(icon: Icons.home, label: 'Home', onTap: () => context.go('/repartidor')),
              _NavItem(icon: Icons.delivery_dining, label: 'Pedidos', isSelected: true, onTap: () {}),
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
