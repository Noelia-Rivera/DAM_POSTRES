import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/admin_bloc.dart';
import '../bloc/categoria_bloc.dart';
import '../widgets/producto_card.dart';
import '../widgets/editar_producto_dialog.dart';
import '../widgets/editar_categoria_dialog.dart';
import '../widgets/admin_drawer.dart';
import '../../domain/entities/categoria.dart';

class VistaAdmin extends StatefulWidget {
  const VistaAdmin({super.key});

  @override
  State<VistaAdmin> createState() => _VistaAdminState();
}

class _VistaAdminState extends State<VistaAdmin> {
  Categoria? categoriaSeleccionada;

  @override
  void initState() {
    super.initState();
    context.read<AdminBloc>().add(const LoadProductos());
    context.read<CategoriaBloc>().add(LoadCategorias());
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
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            decoration: const BoxDecoration(
              color: Color(0xFFD6ADA7),
            ),
            child: SafeArea(
              bottom: false,
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      'Hola, Admin123',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Agregar Postres',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (categoriaState is CategoriaLoading)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: CircularProgressIndicator(),
                      )
                    else if (categoriaState is CategoriaError)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          'Error al cargar categorías: ${categoriaState.message}',
                          style: const TextStyle(color: Colors.red),
                        ),
                      )
                    else
                      _buildCategoriaFilters(categorias),
                    const SizedBox(height: 20),
                    InkWell(
                      onTap: () => context.go('/admin/agregar'),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(40),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300, width: 2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Text(
                            '+ Agregar nuevo producto',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    BlocBuilder<AdminBloc, AdminState>(
                      builder: (context, state) {
                        if (state is AdminLoading) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(40),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        } else if (state is AdminError) {
                          return Center(
                            child: Text('Error: ${state.message}'),
                          );
                        } else if (state is AdminLoaded) {
                          return GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: 0.75,
                            ),
                            itemCount: state.productos.length,
                            itemBuilder: (context, index) {
                              final producto = state.productos[index];
                              return ProductoCard(
                                producto: producto,
                                onEdit: () {
                                  showDialog(
                                    context: context,
                                    builder: (dialogContext) => BlocProvider.value(
                                      value: context.read<AdminBloc>(),
                                      child: EditarProductoDialog(
                                        producto: producto,
                                        categorias: categorias,
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFD6ADA7).withOpacity(0.3),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.home_outlined),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.calendar_today_outlined),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.person_outline),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
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
          border: Border.all(
            color: isSelected ? const Color(0xFFD6ADA7) : Colors.grey.shade300,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoriaFilters(List<Categoria> categorias) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          // Botón + Editar para abrir el diálogo de editar categoría
          _buildEditarButton(categorias),
          const SizedBox(width: 8),
          _buildFilterChip(
            'Todos',
            categoriaSeleccionada == null,
            () {
              setState(() => categoriaSeleccionada = null);
              context.read<AdminBloc>().add(const ChangeCategoria(null));
            },
          ),
          ...categorias.map(
            (categoria) => Padding(
              padding: const EdgeInsets.only(left: 8),
              child: _buildFilterChip(
                categoria.nombre,
                categoriaSeleccionada?.id == categoria.id,
                () {
                  setState(() => categoriaSeleccionada = categoria);
                  context.read<AdminBloc>().add(ChangeCategoria(categoria.nombre));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditarButton(List<Categoria> categorias) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (dialogContext) => BlocProvider.value(
            value: context.read<CategoriaBloc>(),
            child: EditarCategoriaDialog(categorias: categorias),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: const Text(
          '+ Editar',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
