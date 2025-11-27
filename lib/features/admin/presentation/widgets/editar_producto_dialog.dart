import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/producto.dart';
import '../../domain/entities/categoria.dart';
import '../bloc/admin_bloc.dart';

class EditarProductoDialog extends StatefulWidget {
  final Producto producto;
  final List<Categoria> categorias;

  const EditarProductoDialog({
    super.key,
    required this.producto,
    required this.categorias,
  });

  @override
  State<EditarProductoDialog> createState() => _EditarProductoDialogState();
}

class _EditarProductoDialogState extends State<EditarProductoDialog> {
  late TextEditingController _nombreController;
  late TextEditingController _descripcionController;
  late TextEditingController _precioController;
  String? _categoriaIdSeleccionada;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.producto.nombre);
    _descripcionController = TextEditingController(text: widget.producto.descripcion ?? '');
    _precioController = TextEditingController(text: widget.producto.precio.toString());
    _categoriaIdSeleccionada = widget.producto.categoriaId;
    if (_categoriaIdSeleccionada == null && widget.categorias.isNotEmpty) {
      try {
        _categoriaIdSeleccionada = widget.categorias
            .firstWhere((cat) => cat.nombre == widget.producto.categoria)
            .id;
      } catch (_) {
        _categoriaIdSeleccionada = widget.categorias.first.id;
      }
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _descripcionController.dispose();
    _precioController.dispose();
    super.dispose();
  }

  void _guardarCambios() {
    if (_nombreController.text.isEmpty ||
        _precioController.text.isEmpty ||
        (_categoriaIdSeleccionada == null && widget.producto.categoriaId == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor completa todos los campos')),
      );
      return;
    }

    Categoria? categoriaSeleccionada;
    if (_categoriaIdSeleccionada != null) {
      try {
        categoriaSeleccionada = widget.categorias.firstWhere(
          (cat) => cat.id == _categoriaIdSeleccionada,
        );
      } catch (_) {
        categoriaSeleccionada = null;
      }
    }

    final descripcion = _descripcionController.text.trim();

    final productoActualizado = Producto(
      id: widget.producto.id,
      nombre: _nombreController.text,
      precio: double.tryParse(_precioController.text) ?? 0,
      categoria: categoriaSeleccionada?.nombre ?? widget.producto.categoria,
      categoriaId: categoriaSeleccionada?.id ?? widget.producto.categoriaId,
      descripcion: descripcion.isEmpty ? widget.producto.descripcion : descripcion,
      imagenUrl: widget.producto.imagenUrl,
    );

    context.read<AdminBloc>().add(UpdateProducto(productoActualizado));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Editar Producto',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5E6D3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.edit,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _nombreController,
                    decoration: InputDecoration(
                      hintText: 'Nombre',
                      suffixIcon: const Icon(Icons.edit, size: 20),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.orange.shade200),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.orange.shade200),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5E6D3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.description,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    children: [
                      TextField(
                        controller: _descripcionController,
                        decoration: InputDecoration(
                          hintText: 'Desc.',
                          suffixIcon: const Icon(Icons.edit, size: 20),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.orange.shade200),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.orange.shade200),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (widget.categorias.isEmpty)
                        const Text('No hay categorías disponibles', style: TextStyle(color: Colors.red))
                      else
                        DropdownButtonFormField<String>(
                          value: _categoriaIdSeleccionada,
                          hint: const Text('Categoría', style: TextStyle(fontSize: 14)),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.orange.shade200),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.orange.shade200),
                            ),
                          ),
                          items: widget.categorias
                              .map(
                                (cat) => DropdownMenuItem(
                                  value: cat.id,
                                  child: Text(cat.nombre, style: const TextStyle(fontSize: 14)),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _categoriaIdSeleccionada = value;
                            });
                          },
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5E6D3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.attach_money,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _precioController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Precio',
                      suffixIcon: const Icon(Icons.edit, size: 20),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.orange.shade200),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.orange.shade200),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5E6D3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.image,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5E6D3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Editar imagen',
                          style: TextStyle(color: Colors.black54),
                        ),
                        Icon(Icons.settings, size: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _guardarCambios,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB8D77E),
                padding: const EdgeInsets.symmetric(
                  horizontal: 60,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: const Text(
                'Guardar cambios',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
