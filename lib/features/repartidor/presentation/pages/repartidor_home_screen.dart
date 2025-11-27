import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RepartidorHomeScreen extends StatelessWidget {
  const RepartidorHomeScreen({super.key});

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
                  const Text(
                    'vista-repartidor',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
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

            // Contenido principal
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Saludo con icono de editar
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Hola, Repartidor',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.grey,
                            size: 20,
                          ),
                          onPressed: () {
                            // Acción de editar
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Cards de productos
                    Row(
                      children: [
                        Expanded(
                          child: _ProductCard(
                            title: 'Producto 3',
                            price: 0,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _ProductCard(
                            title: 'Producto 4',
                            price: 0,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _BottomNavigationBar(),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final String title;
  final double price;

  const _ProductCard({
    required this.title,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    final pinkColor = const Color(0xFFD7B3AF);

    return Container(
      height: 200,
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
      child: Stack(
        children: [
          Positioned(
            bottom: 16,
            left: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${price.toStringAsFixed(0)}',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.edit,
                color: Colors.grey,
                size: 20,
              ),
            ),
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
                isSelected: true,
                onTap: () {
                  context.go('/repartidor');
                },
              ),
              _NavItem(
                icon: Icons.cake,
                label: 'Pedidos',
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

