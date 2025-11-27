import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/services/api_services.dart';
import '../../../admin/domain/entities/categoria.dart';
import '../../../admin/domain/entities/producto.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Categoria> _categorias = [];
  List<Producto> _productos = [];
  Categoria? _categoriaSeleccionada;
  bool _isLoading = true;
  String? _error;
  String _username = 'usuario';

  @override
  void initState() {
    super.initState();
    _loadData();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    final authService = AuthService();
    final user = await authService.getUser();
    if (user != null && mounted) {
      setState(() => _username = user.username);
    }
  }

  Future<void> _loadData() async {
    setState(() { _isLoading = true; _error = null; });
    try {
      final categorias = await ApiServices.categoriaRepository.getCategorias();
      final productos = await ApiServices.productoRepository.getProductos();
      if (mounted) {
        setState(() { _categorias = categorias; _productos = productos; _isLoading = false; });
      }
    } catch (e) {
      if (mounted) setState(() { _error = e.toString(); _isLoading = false; });
    }
  }

  List<Producto> get _productosFiltrados {
    if (_categoriaSeleccionada == null) return _productos;
    return _productos.where((p) => 
      p.categoriaId == _categoriaSeleccionada!.id || p.categoria == _categoriaSeleccionada!.nombre
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
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
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
                    height: 180, fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(height: 180, color: Colors.grey[200], child: const Icon(Icons.image, size: 50)),
                  ),
                ),
                const SizedBox(height: 20),
                _buildCategorias(),
                const SizedBox(height: 20),
                _buildProductos(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFFD7B3AF),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        showUnselectedLabels: true,
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) context.go('/pedidos');
          if (index == 2) context.go('/profile');
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home Page'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_outlined), label: 'Pedidos'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Mi Perfil'),
        ],
      ),
    );
  }

  Widget _buildCategorias() {
    if (_isLoading) return const SizedBox(height: 40, child: Center(child: CircularProgressIndicator(strokeWidth: 2)));
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _CategoryChip(label: 'Todos', selected: _categoriaSeleccionada == null, onTap: () => setState(() => _categoriaSeleccionada = null)),
          ..._categorias.map((cat) => _CategoryChip(
            label: cat.nombre,
            selected: _categoriaSeleccionada?.id == cat.id,
            onTap: () => setState(() => _categoriaSeleccionada = cat),
          )),
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
        return _ProductCard(image: producto.imagenUrl, title: producto.nombre, price: producto.precio);
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
              const SizedBox(height: 16),
              Container(
                height: 38,
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), borderRadius: BorderRadius.circular(20)),
                child: const TextField(decoration: InputDecoration(hintText: 'Buscar...', hintStyle: TextStyle(color: Colors.grey), prefixIcon: Icon(Icons.search, color: Colors.grey), border: InputBorder.none, contentPadding: EdgeInsets.only(top: 8))),
              ),
              const SizedBox(height: 24),
              const _DrawerItem(icon: Icons.home, label: 'Home'),
              const _DrawerItem(icon: Icons.shopping_cart_outlined, label: 'Carrito'),
              const _DrawerItem(icon: Icons.star_border, label: 'Favoritos'),
              const _DrawerItem(icon: Icons.notifications_none, label: 'Notificaciones'),
              const Spacer(),
              InkWell(
                onTap: () async {
                  await AuthService().logout();
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
  const _DrawerItem({required this.icon, required this.label});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(children: [Icon(icon, color: Colors.white, size: 24), const SizedBox(width: 12), Text(label, style: const TextStyle(color: Colors.white, fontSize: 16))]),
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
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (selected) const Icon(Icons.check, size: 16, color: Colors.white),
              if (selected) const SizedBox(width: 4),
              Text(label, style: TextStyle(color: selected ? Colors.white : Colors.black87, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final String? image;
  final String title;
  final double price;
  const _ProductCard({this.image, required this.title, required this.price});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFD7B3AF)), color: const Color(0xFFF5EAEA)),
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: image != null && image!.isNotEmpty
                  ? Image.network(image!, fit: BoxFit.cover, width: double.infinity, errorBuilder: (_, __, ___) => _placeholder())
                  : _placeholder(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('\$${price.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    Container(width: 28, height: 28, decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFFD7B3AF)), child: const Icon(Icons.add, color: Colors.white, size: 20)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _placeholder() => Container(color: Colors.grey[200], child: const Center(child: Icon(Icons.cake, size: 50, color: Colors.grey)));
}
