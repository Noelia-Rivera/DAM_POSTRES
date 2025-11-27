import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/repartidor_bloc.dart';
import '../../../pedidos/domain/entities/pedido.dart';
import 'repartidor_pedido_detalle_screen.dart';

class RepartidorPedidosScreen extends StatefulWidget {
  const RepartidorPedidosScreen({super.key});

  @override
  State<RepartidorPedidosScreen> createState() => _RepartidorPedidosScreenState();
}

class _RepartidorPedidosScreenState extends State<RepartidorPedidosScreen> {
  String _filtroSeleccionado = 'Todos';

  // TODO: Obtener el ID del repartidor desde el servicio de autenticación
  final String _repartidorId = '1'; // Esto debería venir del AuthService

  @override
  void initState() {
    super.initState();
    context.read<RepartidorBloc>().add(LoadPedidosAsignados(repartidorId: _repartidorId));
  }

  List<Pedido> _filtrarPedidos(List<Pedido> pedidos) {
    switch (_filtroSeleccionado) {
      case 'Enviado':
        return pedidos.where((p) => p.estado == 'Enviado' || p.estado == 'En camino').toList();
      case 'Entregados':
        return pedidos.where((p) => p.estado == 'Entregado').toList();
      default:
        return pedidos;
    }
  }

  @override
  Widget build(BuildContext context) {
    final pinkColor = const Color(0xFFD7B3AF);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: pinkColor),
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.menu,
                        color: Color(0xFFD7B3AF),
                        size: 20,
                      ),
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                    ),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Pedidos',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: pinkColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 20,
                          ),
                          onPressed: () {
                            context.go('/repartidor');
                          },
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.notifications_none,
                            color: Colors.white,
                            size: 20,
                          ),
                          onPressed: () {
                            // Navegar a notificaciones
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Filtros
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _FiltroChip(
                    label: 'Todos',
                    isSelected: _filtroSeleccionado == 'Todos',
                    onTap: () {
                      setState(() {
                        _filtroSeleccionado = 'Todos';
                      });
                    },
                  ),
                  const SizedBox(width: 12),
                  _FiltroChip(
                    label: 'Enviado',
                    isSelected: _filtroSeleccionado == 'Enviado',
                    onTap: () {
                      setState(() {
                        _filtroSeleccionado = 'Enviado';
                      });
                    },
                  ),
                  const SizedBox(width: 12),
                  _FiltroChip(
                    label: 'Entregados',
                    isSelected: _filtroSeleccionado == 'Entregados',
                    onTap: () {
                      setState(() {
                        _filtroSeleccionado = 'Entregados';
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Lista de pedidos
            Expanded(
              child: BlocBuilder<RepartidorBloc, RepartidorState>(
                builder: (context, state) {
                  if (state is RepartidorLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is RepartidorError) {
                    return Center(child: Text('Error: ${state.message}'));
                  } else if (state is PedidosAsignadosLoaded) {
                    final pedidosFiltrados = _filtrarPedidos(state.pedidos);
                    if (pedidosFiltrados.isEmpty) {
                      return const Center(
                        child: Text('No hay pedidos disponibles'),
                      );
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: pedidosFiltrados.length,
                      itemBuilder: (context, index) {
                        final pedido = pedidosFiltrados[index];
                        return _PedidoCard(
                          pedido: pedido,
                          onTap: () {
                            context.push(
                              '/repartidor/pedidos/detalle',
                              extra: pedido,
                            );
                          },
                        );
                      },
                    );
                  }
                  return const Center(child: Text('Cargando pedidos...'));
                },
              ),
            ),
          ],
        ),
      ),
      drawer: _AppDrawer(),
      bottomNavigationBar: _BottomNavigationBar(),
    );
  }
}

class _FiltroChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FiltroChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

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
          border: Border.all(
            color: pinkColor,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

class _PedidoCard extends StatelessWidget {
  final Pedido pedido;
  final VoidCallback onTap;

  const _PedidoCard({
    required this.pedido,
    required this.onTap,
  });

  String _formatearFecha(DateTime fecha) {
    return '${fecha.day}/${fecha.month}/${fecha.year}';
  }

  String _enmascararNumero(String numero) {
    if (numero.length <= 3) return numero;
    return '*****${numero.substring(numero.length - 3)}';
  }

  @override
  Widget build(BuildContext context) {
    final pinkColor = const Color(0xFFD7B3AF);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: pinkColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'PRODUCTO 1',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.info_outline,
                  color: Colors.grey,
                  size: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Num.',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _enmascararNumero(pedido.id),
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Cliente',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'S/. ${pedido.costoTotal.toStringAsFixed(0)}',
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Fecha',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatearFecha(pedido.fechaPedido),
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Total',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'S/. ${pedido.costoTotal.toStringAsFixed(0)}',
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Dirección',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      pedido.direccion,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
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
              context.go('/repartidor');
            },
          ),
          ListTile(
            leading: const Icon(Icons.shopping_bag),
            title: const Text('Pedidos'),
            onTap: () {
              Navigator.pop(context);
              context.go('/repartidor/pedidos');
            },
          ),
        ],
      ),
    );
  }
}

class _BottomNavigationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final pinkColor = const Color(0xFFD7B3AF);

    return Container(
      decoration: BoxDecoration(
        color: pinkColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.home,
                label: 'Home Page',
                onTap: () {
                  context.go('/repartidor');
                },
              ),
              _NavItem(
                icon: Icons.cake,
                label: 'Pedidos',
                isSelected: true,
                onTap: () {
                  context.go('/repartidor/pedidos');
                },
              ),
              _NavItem(
                icon: Icons.person_outline,
                label: 'Mi Perfil',
                onTap: () {
                  context.go('/profile');
                },
              ),
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

  const _NavItem({
    required this.icon,
    required this.label,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

