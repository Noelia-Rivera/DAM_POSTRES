import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/producto.dart';
import '../../domain/entities/categoria.dart';
import '../bloc/admin_bloc.dart';
import '../bloc/categoria_bloc.dart';
import '../widgets/admin_drawer.dart';

class VistaAgregar extends StatefulWidget {
  const VistaAgregar({super.key});

  @override
  State<VistaAgregar> createState() => _VistaAgregarState();
}

class _VistaAgregarState extends State<VistaAgregar> {
  final _nombreController = TextEditingController();
  final _precioController = TextEditingController();
  final _descripcionController = TextEditingController();
  Categoria? _categoriaSeleccionada;

  @override
  void initState() {
    super.initState();
    context.read<CategoriaBloc>().add(LoadCategorias());
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _precioController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  void _crearProducto() {
    if (_nombreController.text.isEmpty ||
        _precioController.text.isEmpty ||
        _categoriaSeleccionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor completa todos los campos')),
      );
      return;
    }

    final categoria = _categoriaSeleccionada!;
    final descripcion = _descripcionController.text.trim();

    final producto = Producto(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      nombre: _nombreController.text,
      precio: double.tryParse(_precioController.text) ?? 0,
      categoria: categoria.nombre,
      categoriaId: categoria.id,
      descripcion: descripcion.isEmpty ? null : descripcion,
    );

    context.read<AdminBloc>().add(CreateProducto(producto));
    context.pop();
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
                      'Agregar Postres',
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
                          _buildFilterChip('Todos', false, () {}),
                          const SizedBox(width: 8),
                          _buildFilterChip('Categoria 1', false, () {}),
                          const SizedBox(width: 8),
                          _buildFilterChip('Categoria 2', false, () {}),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
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
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD6ADA7).withOpacity(0.5),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 150,
                                height: 150,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF5E6D3),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'Seleccionar\nImagen',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: const BoxDecoration(
                                        color: Colors.black,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.add,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Descripción:',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    TextField(
                                      controller: _descripcionController,
                                      maxLines: 4,
                                      decoration: InputDecoration(
                                        hintText: 'Nueva descripción',
                                        filled: true,
                                        fillColor: Colors.white.withOpacity(0.7),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                          borderSide: BorderSide.none,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Nombre:',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _nombreController,
                            decoration: InputDecoration(
                              hintText: 'Nombre',
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.7),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Precio:',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _precioController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: 'Precio',
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.7),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Categoría:',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          BlocBuilder<CategoriaBloc, CategoriaState>(
                            builder: (context, state) {
                              if (state is CategoriaLoading) {
                                return const Center(child: CircularProgressIndicator());
                              } else if (state is CategoriaError) {
                                return Text(
                                  'Error: ${state.message}',
                                  style: const TextStyle(color: Colors.red),
                                );
                              } else if (state is CategoriaLoaded && state.categorias.isNotEmpty) {
                                return DropdownButtonFormField<String>(
                                  value: _categoriaSeleccionada?.id,
                                  hint: const Text('Categorías'),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white.withOpacity(0.7),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                  items: state.categorias
                                      .map(
                                        (cat) => DropdownMenuItem(
                                          value: cat.id,
                                          child: Text(cat.nombre),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: (value) {
                                    if (value == null) return;
                                    final categoriaSeleccionada = state.categorias.firstWhere(
                                      (cat) => cat.id == value,
                                    );
                                    setState(() {
                                      _categoriaSeleccionada = categoriaSeleccionada;
                                    });
                                  },
                                );
                              }
                              return const Text(
                                'No hay categorías disponibles',
                                style: TextStyle(color: Colors.grey),
                              );
                            },
                          ),
                          const SizedBox(height: 24),
                          Center(
                            child: ElevatedButton(
                              onPressed: _crearProducto,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFB8D77E),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 80,
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                              ),
                              child: const Text(
                                'Crear',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
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
