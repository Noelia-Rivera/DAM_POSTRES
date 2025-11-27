import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/pedido.dart';
import 'pedido_direccion_dialog.dart';
import 'pedido_confirmacion_screen.dart';

class PedidoDetalleScreen extends StatefulWidget {
  final Pedido pedido;

  const PedidoDetalleScreen({
    super.key,
    required this.pedido,
  });

  @override
  State<PedidoDetalleScreen> createState() => _PedidoDetalleScreenState();
}

class _PedidoDetalleScreenState extends State<PedidoDetalleScreen> {
  late String direccion;

  @override
  void initState() {
    super.initState();
    direccion = widget.pedido.direccion;
  }

  void _mostrarDialogDireccion() async {
    final resultado = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => PedidoDireccionDialog(
        direccionActual: direccion,
      ),
    );

    if (resultado != null) {
      setState(() {
        direccion = '${resultado['departamento']} - ${resultado['distrito']} - ${resultado['direccion']}';
      });
    }
  }

  void _confirmarPedido() {
    context.push(
      '/pedidos/confirmacion',
      extra: {
        'pedido': widget.pedido,
        'direccion': direccion,
      },
    );
  }

  String _formatearFecha(DateTime fecha) {
    return '${fecha.day}/${fecha.month}/${fecha.year}';
  }

  @override
  Widget build(BuildContext context) {
    final pinkColor = const Color(0xFFD7B3AF);
    final greenColor = const Color(0xFFBACB95);

    return Scaffold(
      backgroundColor: Colors.white,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFFD7B3AF),
              ),
              child: Text(
                'Menú',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Inicio'),
              onTap: () {
                Navigator.pop(context);
                context.go('/cliente');
              },
            ),
            ListTile(
              leading: const Icon(Icons.shopping_bag),
              title: const Text('Pedidos'),
              onTap: () {
                Navigator.pop(context);
                context.go('/pedidos');
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Row(
                  children: [
                    const Text(
                      'pedido-L',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: pinkColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.menu,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        },
                      ),
                    ),
                  ],
                ),
              ),
              // Barra rosa
              Container(
                height: 4,
                color: pinkColor,
                margin: const EdgeInsets.symmetric(horizontal: 16),
              ),
              const SizedBox(height: 16),

              // Sección de pedido de usuario
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Pedido de usuario',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: pinkColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.add_circle_outline,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: pinkColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.notifications_none,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  widget.pedido.id,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Card principal con información del usuario
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: pinkColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 60,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        widget.pedido.nombreUsuario,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.pedido.apodo,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Costo total',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'S/. ${widget.pedido.costoTotal.toStringAsFixed(0)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Información detallada del pedido
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    // Fecha de pedido
                    _InfoRow(
                      icon: Icons.calendar_today,
                      label: 'Fecha de pedido',
                      value: _formatearFecha(widget.pedido.fechaPedido),
                    ),
                    const SizedBox(height: 12),
                    // Fecha de entrega
                    _InfoRow(
                      icon: Icons.event_available,
                      label: 'Fecha de entrega',
                      value: _formatearFecha(widget.pedido.fechaEntrega),
                      iconOverlay: Icons.access_time,
                    ),
                    const SizedBox(height: 12),
                    // Repartidor
                    _InfoRow(
                      icon: Icons.delivery_dining,
                      label: 'Repartidor',
                      value: widget.pedido.repartidor,
                    ),
                    const SizedBox(height: 12),
                    // Dirección (editable)
                    _DireccionRow(
                      direccion: direccion,
                      onTap: _mostrarDialogDireccion,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Botón de confirmar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _confirmarPedido,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: greenColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Confirmar',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final IconData? iconOverlay;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.iconOverlay,
  });

  @override
  Widget build(BuildContext context) {
    final pinkColor = const Color(0xFFD7B3AF);

    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Stack(
            children: [
              Center(
                child: Icon(
                  icon,
                  color: Colors.black87,
                  size: 24,
                ),
              ),
              if (iconOverlay != null)
                Positioned(
                  bottom: 4,
                  right: 4,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      iconOverlay,
                      color: Colors.black87,
                      size: 12,
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: pinkColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _DireccionRow extends StatelessWidget {
  final String direccion;
  final VoidCallback onTap;

  const _DireccionRow({
    required this.direccion,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final pinkColor = const Color(0xFFD7B3AF);

    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: const Icon(
            Icons.location_on,
            color: Colors.black87,
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: InkWell(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: pinkColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Dir.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          direccion,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.edit,
                    color: Colors.black87,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

