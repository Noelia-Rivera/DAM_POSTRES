import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/categoria_bloc.dart';
import '../widgets/categoria_card.dart';
import '../widgets/crear_categoria_dialog.dart';
import '../widgets/admin_drawer.dart';

class VistaCategoria extends StatefulWidget {
  const VistaCategoria({super.key});

  @override
  State<VistaCategoria> createState() => _VistaCategoriaState();
}

class _VistaCategoriaState extends State<VistaCategoria> {
  @override
  void initState() {
    super.initState();
    context.read<CategoriaBloc>().add(LoadCategorias());
  }

  void _mostrarDialogoCrear() {
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<CategoriaBloc>(),
        child: const CrearCategoriaDialog(),
      ),
    );
  }

  void _mostrarDialogoEditar(categoria) {
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<CategoriaBloc>(),
        child: CrearCategoriaDialog(categoria: categoria),
      ),
    );
  }

  void _confirmarEliminar(String id, String nombre) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Eliminar Categoría'),
        content: Text('¿Estás seguro de eliminar "$nombre"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<CategoriaBloc>().add(DeleteCategoria(id));
              Navigator.of(dialogContext).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                      'Gestionar Categorías',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildFilterChip('+ Editar', false, () {}),
                          const SizedBox(width: 8),
                          _buildFilterChip('Todos', true, () {}),
                          const SizedBox(width: 8),
                          _buildFilterChip('Categoria 1', false, () {}),
                          const SizedBox(width: 8),
                          _buildFilterChip('Categoria 2', false, () {}),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    InkWell(
                      onTap: _mostrarDialogoCrear,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(40),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300, width: 2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Text(
                            '+ Agregar nueva categoría',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    BlocBuilder<CategoriaBloc, CategoriaState>(
                      builder: (context, state) {
                        if (state is CategoriaLoading) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(40),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        } else if (state is CategoriaError) {
                          return Center(
                            child: Text('Error: ${state.message}'),
                          );
                        } else if (state is CategoriaLoaded) {
                          return ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: state.categorias.length,
                            separatorBuilder: (context, index) => const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final categoria = state.categorias[index];
                              return CategoriaCard(
                                categoria: categoria,
                                onEdit: () => _mostrarDialogoEditar(categoria),
                                onDelete: () => _confirmarEliminar(
                                  categoria.id,
                                  categoria.nombre,
                                ),
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
}
