import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/categoria.dart';
import '../bloc/categoria_bloc.dart';

class EditarCategoriaDialog extends StatefulWidget {
  final List<Categoria> categorias;

  const EditarCategoriaDialog({
    super.key,
    required this.categorias,
  });

  @override
  State<EditarCategoriaDialog> createState() => _EditarCategoriaDialogState();
}

class _EditarCategoriaDialogState extends State<EditarCategoriaDialog> {
  late TextEditingController _nombreController;
  Categoria? _categoriaSeleccionada;
  String? _accionSeleccionada;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController();
  }

  @override
  void dispose() {
    _nombreController.dispose();
    super.dispose();
  }

  void _guardarCambios() {
    if (_categoriaSeleccionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor selecciona una categoría')),
      );
      return;
    }

    if (_accionSeleccionada == 'Eliminar') {
      _mostrarConfirmacionEliminar();
      return;
    }

    // Acción Editar
    if (_nombreController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor ingresa un nuevo nombre')),
      );
      return;
    }

    final categoriaActualizada = Categoria(
      id: _categoriaSeleccionada!.id,
      nombre: _nombreController.text,
    );
    context.read<CategoriaBloc>().add(UpdateCategoria(categoriaActualizada));
    Navigator.of(context).pop();
  }

  void _mostrarConfirmacionEliminar() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text('Confirmar eliminación'),
        content: Text(
          '¿Estás seguro de eliminar la categoría "${_categoriaSeleccionada!.nombre}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              this.context.read<CategoriaBloc>().add(
                    DeleteCategoria(_categoriaSeleccionada!.id),
                  );
              Navigator.of(context).pop(); // Cierra confirmación
              Navigator.of(this.context).pop(); // Cierra diálogo principal
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text(
              'Eliminar',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
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
              'Editar Categoría',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 24),
            // Campo de texto para nuevo nombre
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5E6D3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.edit_outlined,
                    color: Colors.black54,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _nombreController,
                    decoration: InputDecoration(
                      hintText: 'Nueva Categoría',
                      hintStyle: TextStyle(color: Colors.grey.shade500),
                      suffixIcon: Icon(
                        Icons.edit,
                        size: 18,
                        color: Colors.grey.shade400,
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.orange.shade200),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.orange.shade200),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.orange.shade300, width: 2),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Dropdowns de categoría y acción
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5E6D3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.folder_outlined,
                    color: Colors.black54,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.orange.shade200),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<Categoria>(
                        value: _categoriaSeleccionada,
                        hint: Text(
                          'Categoría',
                          style: TextStyle(color: Colors.grey.shade500),
                        ),
                        isExpanded: true,
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.orange.shade300,
                        ),
                        items: widget.categorias
                            .map((cat) => DropdownMenuItem(
                                  value: cat,
                                  child: Text(cat.nombre),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _categoriaSeleccionada = value;
                            _nombreController.text = value?.nombre ?? '';
                          });
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.orange.shade200),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _accionSeleccionada,
                        hint: Text(
                          'Editar',
                          style: TextStyle(color: Colors.grey.shade500),
                        ),
                        isExpanded: true,
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.orange.shade300,
                        ),
                        items: ['Editar', 'Eliminar']
                            .map((action) => DropdownMenuItem(
                                  value: action,
                                  child: Text(action),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() => _accionSeleccionada = value);
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),
            // Botón guardar cambios
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _guardarCambios,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB8D77E),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Guardar cambios',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
