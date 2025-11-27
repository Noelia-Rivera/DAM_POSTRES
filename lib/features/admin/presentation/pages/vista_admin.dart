import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/admin_bloc.dart';
import '../bloc/categoria_bloc.dart';
import '../widgets/producto_card.dart';
import '../widgets/editar_producto_dialog.dart';
import '../widgets/editar_categoria_dialog.dart';
import '../widgets/crear_categoria_dialog.dart';
import '../widgets/admin_drawer.dart';
import '../../domain/entities/categoria.dart';

class VistaAdmin extends StatefulWidget {
  const VistaAdmin({super.key});

  @override
  State<VistaAdmin> createState() => _VistaAdminState();
}

class _VistaAdminState extends State<VistaAdmin> with SingleTickerProviderStateMixin {
  Categoria? categoriaSeleccionada;
  late TabController _tabController;
  int _currentNavIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    context.read<AdminBloc>().add(const LoadProductos());
    context.read<CategoriaBloc>().add(LoadCategorias());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categoriaState = context.watch<CategoriaBloc>().state;
    final categorias = categoriaState is CategoriaLoaded ? categoriaState.categorias : <Categoria>[];

    return Scaffold(
      backgroundColor: Colors.white,
      drawer: const AdminDrawer(),
      body: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(color: Color(0xFFD6ADA7)),
            child: SafeArea(
              bottom: false,
              child: Row(
                children: [
                  Builder(
                    builder: (ctx) => Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.menu, color: Colors.white),
                        onPressed: () => Scaffold.of(ctx).openDrawer(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Contenido principal
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text('Hola, Admin123', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    const Text('Agregar Postres', style: TextStyle(fontSize: 14, color: Colors.grey)),
                    const SizedBox(height: 20),
                    _buildCategoriaFilters(categorias, categoriaState),
                    const SizedBox(height: 20),
                    _buildAgregarProductoButton(),
                    const SizedBox(height: 20),
                    _buildProductosGrid(categorias),
                  ],
                ),
              ),
            ),
          ),
          // Bottom Navigation
          _buildBottomNav(),
        ],
      ),
    );
  }

  Widget _buildCategoriaFilters(List<Categoria> categorias, CategoriaState state) {
    if (state is CategoriaLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }
    if (state is CategoriaError) {
      return Text('Error: ${state.message}', style: const TextStyle(color: Colors.red));
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          // Botón + Editar
          _buildActionButton('+ Editar', () => _showEditarCategoriaDialog(categorias)),
          const SizedBox(width: 8),
          // Botón + Crear
          _buildActionButton('+ Crear', () => _showCrearCategoriaDialog()),
          const SizedBox(width: 8),
          // Filtro Todos
          _buildFilterChip('Todos', categoriaSeleccionada == null, () {
            setState(() => categoriaSeleccionada = null);
            context.read<AdminBloc>().add(const ChangeCategoria(null));
          }),
          // Filtros de categorías
          ...categorias.map((cat) => Padding(
            padding: const EdgeInsets.only(left: 8),
            child: _buildFilterChip(cat.nombre, categoriaSeleccionada?.id == cat.id, () {
              setState(() => categoriaSeleccionada = cat);
              context.read<AdminBloc>().add(ChangeCategoria(cat.nombre));
            }),
          )),
        ],
      ),
    );
  }

  Widget _buildActionButton(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Text(label, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFD6ADA7) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? const Color(0xFFD6ADA7) : Colors.grey.shade300),
        ),
        child: Text(label, style: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        )),
      ),
    );
  }

  Widget _buildAgregarProductoButton() {
    return InkWell(
      onTap: () => context.go('/admin/agregar'),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Text('+ Agregar nuevo producto', style: TextStyle(color: Colors.grey, fontSize: 16)),
        ),
      ),
    );
  }

  Widget _buildProductosGrid(List<Categoria> categorias) {
    return BlocBuilder<AdminBloc, AdminState>(
      builder: (context, state) {
        if (state is AdminLoading) {
          return const Padding(padding: EdgeInsets.all(40), child: CircularProgressIndicator());
        }
        if (state is AdminError) {
          return Center(child: Text('Error: ${state.message}'));
        }
        if (state is AdminLoaded) {
          if (state.productos.isEmpty) {
            return const Padding(
              padding: EdgeInsets.all(40),
              child: Text('No hay productos', style: TextStyle(color: Colors.grey)),
            );
          }
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: 0.75,
            ),
            itemCount: state.productos.length,
            itemBuilder: (context, index) {
              final producto = state.productos[index];
              return ProductoCard(
                producto: producto,
                onEdit: () => _showEditarProductoDialog(producto, categorias),
              );
            },
          );
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFD6ADA7),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home_outlined, 'Inicio', 0),
              _buildNavItem(Icons.calendar_today_outlined, 'Pedidos', 1),
              _buildNavItem(Icons.person_outline, 'Perfil', 2),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _currentNavIndex == index;
    return InkWell(
      onTap: () {
        setState(() => _currentNavIndex = index);
        if (index == 1) context.go('/pedidos');
        if (index == 2) context.go('/profile');
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: isSelected ? Colors.white : Colors.white70),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(
            color: isSelected ? Colors.white : Colors.white70,
            fontSize: 12,
          )),
        ],
      ),
    );
  }

  void _showEditarCategoriaDialog(List<Categoria> categorias) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<CategoriaBloc>(),
        child: EditarCategoriaDialog(categorias: categorias),
      ),
    );
  }

  void _showCrearCategoriaDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<CategoriaBloc>(),
        child: const CrearCategoriaDialog(),
      ),
    );
  }

  void _showEditarProductoDialog(producto, List<Categoria> categorias) {
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<AdminBloc>(),
        child: EditarProductoDialog(producto: producto, categorias: categorias),
      ),
    );
  }
}
