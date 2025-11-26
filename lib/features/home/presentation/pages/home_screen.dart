import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

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

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              const Text(
                'Hola, usuario',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Text(
                'Seleccione sus postres',
                style: TextStyle(color: Colors.grey, fontSize: 15),
              ),
              const SizedBox(height: 20),

              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  'https://www.shutterstock.com/shutterstock/photos/2602005109/display_1500/stock-photo-delicious-cupcake-with-cream-and-red-berries-isolated-on-white-background-2602005109.jpg',
                  height: 180,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: const [
                    _CategoryChip(label: 'Todos', selected: true),
                    _CategoryChip(label: 'Categoria 1'),
                    _CategoryChip(label: 'Categoria 2'),
                    _CategoryChip(label: 'Categoria 3'),
                    SizedBox(width: 10),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.8,
                children: const [
                  _ProductCard(
                    image:
                        'https://www.shutterstock.com/shutterstock/photos/2090916361/display_1500/stock-photo-strawberry-cheesecake-isolated-on-white-background-2090916361.jpg',
                    title: 'Producto 1',
                    price: 0,
                  ),
                  _ProductCard(
                    image:
                        'https://www.shutterstock.com/shutterstock/photos/1843287602/display_1500/stock-photo-slice-of-cheesecake-with-strawberry-sauce-isolated-on-white-background-1843287602.jpg',
                    title: 'Producto 2',
                    price: 0,
                  ),
                  _ProductCard(
                    image:
                        'https://www.shutterstock.com/shutterstock/photos/236009799/display_1500/stock-photo-puff-pastry-cake-with-peach-isolated-on-white-background-236009799.jpg',
                    title: 'Producto 3',
                    price: 0,
                  ),
                  _ProductCard(
                    image:
                        'https://www.shutterstock.com/shutterstock/photos/254713616/display_1500/stock-photo-fruit-tart-with-berries-isolated-on-white-background-254713616.jpg',
                    title: 'Producto 4',
                    price: 0,
                  ),
                ],
              ),
            ],
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
          if (index == 2) context.go('/profile');
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home Page'),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined),
            label: 'Pedidos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Mi Perfil',
          ),
        ],
      ),
    );
  }
}

class _AppDrawer extends StatelessWidget {
  const _AppDrawer();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      backgroundColor: const Color(0xFFD7B3AF),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const Text(
                'POSTRECITOS',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 16),

              Container(
                height: 38,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: 'Buscar...',
                    hintStyle: TextStyle(color: Colors.grey),
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(top: 8),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              const _DrawerItem(icon: Icons.home, label: 'Home'),
              const _DrawerItem(
                icon: Icons.shopping_cart_outlined,
                label: 'Carrito',
              ),
              const _DrawerItem(icon: Icons.star_border, label: 'Favoritos'),
              const _DrawerItem(
                icon: Icons.notifications_none,
                label: 'Notificaciones',
              ),

              const Spacer(),

              InkWell(
                onTap: () {
                  Navigator.pop(context);
                  context.go('/');
                },
                child: Row(
                  children: const [
                    Icon(Icons.logout, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      'Cerrar Sesión',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
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
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 24),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool selected;

  const _CategoryChip({required this.label, this.selected = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        labelStyle: TextStyle(
          color: selected ? Colors.white : Colors.black87,
          fontWeight: FontWeight.w500,
        ),
        selected: selected,
        onSelected: (_) {},
        backgroundColor: Colors.white,
        selectedColor: const Color(0xFFD7B3AF),
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: selected ? Colors.transparent : Colors.grey.shade400,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final String image;
  final String title;
  final double price;

  const _ProductCard({
    required this.image,
    required this.title,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD7B3AF)),
        color: const Color(0xFFF5EAEA),
      ),
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: Image.network(image, fit: BoxFit.cover),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${0.toStringAsFixed(0)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFD7B3AF),
                    ),
                    child: const Icon(Icons.add, color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
