import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/services/api_services.dart';
import '../../../pedidos/data/models/pedido_model.dart';
import '../../../repartidor/data/models/repartidor_model.dart';

class AdminPedidosScreen extends StatefulWidget {
  const AdminPedidosScreen({super.key});

  @override
  State<AdminPedidosScreen> createState() => _AdminPedidosScreenState();
}

class _AdminPedidosScreenState extends State<AdminPedidosScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<PedidoModel> _pedidos = [];
  List<RepartidorModel> _repartidores = [];
  bool _isLoading = true;
  String? _error;

  final _estados = ['TODOS', 'PENDIENTE', 'ACEPTADO', 'EN_PREPARACION', 'LISTO_PARA_ENTREGA', 'EN_CAMINO', 'ENTREGADO', 'CANCELADO'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _estados.length, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() { _isLoading = true; _error = null; });
    try {
      final pedidos = await ApiServices.pedidoDataSource.getPedidos();
      final repartidores = await ApiServices.repartidorDataSource.getRepartidores();
      if (mounted) setState(() { _pedidos = pedidos; _repartidores = repartidores; _isLoading = false; });
    } catch (e) {
      if (mounted) setState(() { _error = e.toString(); _isLoading = false; });
    }
  }

  List<PedidoModel> _filtrarPedidos(String estado) {
    if (estado == 'TODOS') return _pedidos;
    return _pedidos.where((p) => p.estado.toUpperCase() == estado).toList();
  }

  Future<void> _aceptarPedido(PedidoModel pedido) async {
    try {
      await ApiServices.pedidoDataSource.aceptarPedido(pedido.id);
      _showSuccess('Pedido aceptado');
      _loadData();
    } catch (e) { _showError('Error: $e'); }
  }

  Future<void> _enPreparacion(PedidoModel pedido) async {
    try {
      await ApiServices.pedidoDataSource.marcarEnPreparacion(pedido.id);
      _showSuccess('Pedido en preparación');
      _loadData();
    } catch (e) { _showError('Error: $e'); }
  }

  Future<void> _listoParaEntrega(PedidoModel pedido) async {
    try {
      await ApiServices.pedidoDataSource.marcarListoParaEntrega(pedido.id);
      _showSuccess('Pedido listo para entrega');
      _loadData();
    } catch (e) { _showError('Error: $e'); }
  }

  Future<void> _cancelarPedido(PedidoModel pedido) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancelar Pedido'),
        content: Text('¿Cancelar el pedido #${pedido.id}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('No')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Sí', style: TextStyle(color: Colors.red))),
        ],
      ),
    );
    if (confirm == true) {
      try {
        await ApiServices.pedidoDataSource.cancelarPedido(pedido.id);
        _showSuccess('Pedido cancelado');
        _loadData();
      } catch (e) { _showError('Error: $e'); }
    }
  }

  Future<void> _asignarRepartidor(PedidoModel pedido) async {
    final repartidor = await showDialog<RepartidorModel>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Asignar Repartidor'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _repartidores.length,
            itemBuilder: (_, i) {
              final r = _repartidores[i];
              return ListTile(
                leading: const CircleAvatar(child: Icon(Icons.person)),
                title: Text(r.codigo ?? 'Repartidor ${r.id}'),
                subtitle: Text('ID: ${r.id}'),
                onTap: () => Navigator.pop(ctx, r),
              );
            },
          ),
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar'))],
      ),
    );
    if (repartidor != null) {
      try {
        await ApiServices.pedidoDataSource.asignarRepartidor(pedido.id, repartidor.id.toString());
        _showSuccess('Repartidor asignado');
        _loadData();
      } catch (e) { _showError('Error: $e'); }
    }
  }

  void _showSuccess(String msg) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.green));
  void _showError(String msg) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.red));

  Color _getEstadoColor(String estado) {
    switch (estado.toUpperCase()) {
      case 'PENDIENTE': return Colors.orange;
      case 'ACEPTADO': return Colors.blue;
      case 'EN_PREPARACION': return Colors.purple;
      case 'LISTO_PARA_ENTREGA': return Colors.teal;
      case 'EN_CAMINO': return Colors.indigo;
      case 'ENTREGADO': return Colors.green;
      case 'CANCELADO': return Colors.red;
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final pinkColor = const Color(0xFFD7B3AF);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: pinkColor,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => context.pop()),
        title: const Text('Gestión de Pedidos', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [IconButton(icon: const Icon(Icons.refresh, color: Colors.white), onPressed: _loadData)],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: _estados.map((e) => Tab(text: e.replaceAll('_', ' '))).toList(),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Text('Error: $_error'), ElevatedButton(onPressed: _loadData, child: const Text('Reintentar'))]))
              : TabBarView(
                  controller: _tabController,
                  children: _estados.map((estado) => _buildPedidosList(_filtrarPedidos(estado))).toList(),
                ),
    );
  }

  Widget _buildPedidosList(List<PedidoModel> pedidos) {
    if (pedidos.isEmpty) {
      return const Center(child: Text('No hay pedidos', style: TextStyle(color: Colors.grey, fontSize: 16)));
    }
    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: pedidos.length,
        itemBuilder: (context, index) => _AdminPedidoCard(
          pedido: pedidos[index],
          estadoColor: _getEstadoColor(pedidos[index].estado),
          onAceptar: () => _aceptarPedido(pedidos[index]),
          onEnPreparacion: () => _enPreparacion(pedidos[index]),
          onListoEntrega: () => _listoParaEntrega(pedidos[index]),
          onAsignarRepartidor: () => _asignarRepartidor(pedidos[index]),
          onCancelar: () => _cancelarPedido(pedidos[index]),
        ),
      ),
    );
  }
}


class _AdminPedidoCard extends StatelessWidget {
  final PedidoModel pedido;
  final Color estadoColor;
  final VoidCallback onAceptar;
  final VoidCallback onEnPreparacion;
  final VoidCallback onListoEntrega;
  final VoidCallback onAsignarRepartidor;
  final VoidCallback onCancelar;

  const _AdminPedidoCard({
    required this.pedido,
    required this.estadoColor,
    required this.onAceptar,
    required this.onEnPreparacion,
    required this.onListoEntrega,
    required this.onAsignarRepartidor,
    required this.onCancelar,
  });

  @override
  Widget build(BuildContext context) {
    final pinkColor = const Color(0xFFD7B3AF);
    final estado = pedido.estado.toUpperCase();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: pinkColor.withOpacity(0.15), borderRadius: const BorderRadius.vertical(top: Radius.circular(16))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Pedido #${pedido.id}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 4),
                  Text('Cliente: ${pedido.nombreUsuario}', style: TextStyle(color: Colors.grey[600])),
                ]),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(color: estadoColor, borderRadius: BorderRadius.circular(20)),
                  child: Text(pedido.estado.replaceAll('_', ' '), style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          // Info
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(children: [
                  Expanded(child: _InfoItem(icon: Icons.calendar_today, label: 'Pedido', value: _formatDate(pedido.fechaPedido))),
                  Expanded(child: _InfoItem(icon: Icons.event, label: 'Entrega', value: '${_formatDate(pedido.fechaEntrega)} ${pedido.horaEntrega ?? ''}')),
                ]),
                const SizedBox(height: 12),
                _InfoItem(icon: Icons.location_on, label: 'Dirección', value: pedido.direccion),
                const SizedBox(height: 12),
                _InfoItem(icon: Icons.delivery_dining, label: 'Repartidor', value: pedido.repartidor),
                const Divider(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    Text('S/. ${pedido.costoTotal.toStringAsFixed(2)}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: pinkColor)),
                  ],
                ),
              ],
            ),
          ),
          // Acciones
          if (estado != 'ENTREGADO' && estado != 'CANCELADO')
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.grey[50], borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16))),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: [
                  if (estado == 'PENDIENTE') ...[
                    _ActionButton(label: 'Aceptar', icon: Icons.check, color: Colors.green, onTap: onAceptar),
                    _ActionButton(label: 'Cancelar', icon: Icons.close, color: Colors.red, onTap: onCancelar),
                  ],
                  if (estado == 'ACEPTADO')
                    _ActionButton(label: 'En Preparación', icon: Icons.restaurant, color: Colors.purple, onTap: onEnPreparacion),
                  if (estado == 'EN_PREPARACION')
                    _ActionButton(label: 'Listo', icon: Icons.check_circle, color: Colors.teal, onTap: onListoEntrega),
                  if (estado == 'LISTO_PARA_ENTREGA' && pedido.repartidor == 'Sin asignar')
                    _ActionButton(label: 'Asignar Repartidor', icon: Icons.person_add, color: Colors.indigo, onTap: onAsignarRepartidor),
                  if (estado != 'PENDIENTE' && estado != 'CANCELADO')
                    _ActionButton(label: 'Cancelar', icon: Icons.cancel, color: Colors.red.shade300, onTap: onCancelar),
                ],
              ),
            ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) => '${date.day}/${date.month}/${date.year}';
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoItem({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey),
        const SizedBox(width: 6),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
            Text(value, style: const TextStyle(fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis),
          ]),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _ActionButton({required this.label, required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}
