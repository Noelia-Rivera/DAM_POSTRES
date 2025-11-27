import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/services/api_services.dart';
import '../../../../core/services/notification_service.dart';
import '../../../admin/domain/entities/categoria.dart';
import '../../../admin/domain/entities/producto.dart';
import '../providers/carrito_provider.dart';

class ClienteHomeScreen extends StatefulWidget {
  const ClienteHomeScreen({super.key});

  @override
  State<ClienteHomeScreen> createState() => _ClienteHomeScreenState();
}

class _ClienteHomeScreenState extends State<ClienteHomeScreen> {
  List<Categoria> _categorias = [];
  List<Producto> _productos = [];
  Categoria? _categoriaSeleccionada;
  bool _isLoading = true;
  String? _error;
  String _username = 'Cliente';
  
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
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final categorias = await ApiServices.categoriaRepository.getCategorias();
      final productos = await ApiServices.productoRepository.getProductos();
      
      if (mounted) {
        setState(() {
          _categorias = categorias;
          _productos = productos;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  List<Producto> get _productosFiltrados {
    if (_categoriaSeleccionada == null) return _productos;
    return _productos.where((p) => 
      p.categoriaId == _categoriaSeleccionada!.id ||
      p.categoria == _categoriaSeleccionada!.nombre
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFD7B3AF),
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: const _AppDrawer(),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 16),
                Text('Hola, $_username', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const Text('Seleccione sus postres', style: TextStyle(color: Colors.grey, fontSize: 15)),
                const SizedBox(height: 20),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    'https://www.shutterstock.com/shutterstock/photos/2602005109/display_1500/stock-photo-delicious-cupcake-with-cream-and-red-berries-isolated-on-white-background-2602005109.jpg',
                    height: 180,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(height: 180, color: Colors.grey[200], child: const Icon(Icons.image, size: 50)),
                  ),
                ),
                const SizedBox(height: 20),
                _buildCategorias(),
                const SizedBox(height: 20),
                _buildProductos(),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Consumer<CarritoProvider>(
        builder: (context, carrito, _) {
          if (carrito.isEmpty) return const SizedBox();
          return FloatingActionButton.extended(
            onPressed: () => context.push('/cliente/carrito'),
            backgroundColor: const Color(0xFFD7B3AF),
            icon: const Icon(Icons.shopping_cart, color: Colors.white),
            label: Text('${carrito.cantidadTotal} - S/. ${carrito.total.toStringAsFixed(2)}',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFFD7B3AF),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        showUnselectedLabels: true,
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) context.push('/cliente/carrito');
          if (index == 2) context.push('/cliente/mis-pedidos');
          if (index == 3) context.go('/profile');
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_outlined), label: 'Carrito'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'Pedidos'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Perfil'),
        ],
      ),
    );
  }

  Widget _buildCategorias() {
    if (_isLoading) {
      return const SizedBox(height: 40, child: Center(child: CircularProgressIndicator(strokeWidth: 2)));
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _CategoryChip(label: 'Todos', selected: _categoriaSeleccionada == null, onTap: () => setState(() => _categoriaSeleccionada = null)),
          ..._categorias.map((cat) => _CategoryChip(label: cat.nombre, selected: _categoriaSeleccionada?.id == cat.id, onTap: () => setState(() => _categoriaSeleccionada = cat))),
        ],
      ),
    );
  }

  Widget _buildProductos() {
    if (_isLoading) return const Padding(padding: EdgeInsets.all(40), child: CircularProgressIndicator());
    if (_error != null) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          Text('Error: $_error', style: const TextStyle(color: Colors.red)),
          const SizedBox(height: 10),
          ElevatedButton(onPressed: _loadData, child: const Text('Reintentar')),
        ]),
      );
    }
    if (_productosFiltrados.isEmpty) {
      return const Padding(padding: EdgeInsets.all(40), child: Text('No hay productos disponibles', style: TextStyle(color: Colors.grey)));
    }
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 0.8),
      itemCount: _productosFiltrados.length,
      itemBuilder: (context, index) {
        final producto = _productosFiltrados[index];
        return _ProductCard(
          producto: producto,
          onAdd: () {
            context.read<CarritoProvider>().agregarProducto(producto);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${producto.nombre} agregado'), duration: const Duration(seconds: 1), behavior: SnackBarBehavior.floating));
          },
        );
      },
    );
  }
}


class _AppDrawer extends StatelessWidget {
  const _AppDrawer();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(30), bottomRight: Radius.circular(30))),
      backgroundColor: const Color(0xFFD7B3AF),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const Text('POSTRECITOS', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18, letterSpacing: 1)),
              const SizedBox(height: 24),
              _DrawerItem(icon: Icons.home, label: 'Home', onTap: () => Navigator.pop(context)),
              _DrawerItem(icon: Icons.shopping_cart_outlined, label: 'Carrito', onTap: () { Navigator.pop(context); context.push('/cliente/carrito'); }),
              _DrawerItem(icon: Icons.receipt_long, label: 'Mis Pedidos', onTap: () { Navigator.pop(context); context.push('/cliente/mis-pedidos'); }),
              const Spacer(),
              InkWell(
                onTap: () async {
                  final authService = AuthService();
                  await authService.logout();
                  if (context.mounted) { Navigator.pop(context); context.go('/'); }
                },
                child: const Row(children: [Icon(Icons.logout, color: Colors.white), SizedBox(width: 8), Text('Cerrar Sesión', style: TextStyle(color: Colors.white, fontSize: 16))]),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  const _DrawerItem({required this.icon, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(children: [Icon(icon, color: Colors.white, size: 24), const SizedBox(width: 12), Text(label, style: const TextStyle(color: Colors.white, fontSize: 16))]),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _CategoryChip({required this.label, this.selected = false, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFFD7B3AF) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: selected ? Colors.transparent : Colors.grey.shade400),
          ),
          child: Text(label, style: TextStyle(color: selected ? Colors.white : Colors.black87, fontWeight: FontWeight.w500)),
        ),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Producto producto;
  final VoidCallback onAdd;
  const _ProductCard({required this.producto, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    final carrito = context.watch<CarritoProvider>();
    final cantidad = carrito.getCantidadProducto(producto.id);

    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFD7B3AF)), color: const Color(0xFFF5EAEA)),
      child: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  child: producto.imagenUrl != null && producto.imagenUrl!.isNotEmpty
                      ? Image.network(producto.imagenUrl!, fit: BoxFit.cover, width: double.infinity, height: double.infinity, errorBuilder: (_, __, ___) => _buildPlaceholder())
                      : _buildPlaceholder(),
                ),
                if (cantidad > 0)
                  Positioned(
                    top: 8, right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: const Color(0xFFD7B3AF), borderRadius: BorderRadius.circular(12)),
                      child: Text('$cantidad', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(producto.nombre, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('S/. ${producto.precio.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    GestureDetector(
                      onTap: onAdd,
                      child: Container(
                        width: 28, height: 28,
                        decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFFD7B3AF)),
                        child: const Icon(Icons.add, color: Colors.white, size: 20),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() => Container(color: Colors.grey[200], child: const Center(child: Icon(Icons.cake, size: 50, color: Colors.grey)));
}
