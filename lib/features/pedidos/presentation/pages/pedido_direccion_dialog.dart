import 'package:flutter/material.dart';

class PedidoDireccionDialog extends StatefulWidget {
  final String direccionActual;

  const PedidoDireccionDialog({
    super.key,
    required this.direccionActual,
  });

  @override
  State<PedidoDireccionDialog> createState() => _PedidoDireccionDialogState();
}

class _PedidoDireccionDialogState extends State<PedidoDireccionDialog> {
  late TextEditingController _departamentoController;
  late TextEditingController _distritoController;
  late TextEditingController _direccionController;

  @override
  void initState() {
    super.initState();
    // Parsear la dirección actual si está en formato "Lima - Miraflores - Mz8b"
    final partes = widget.direccionActual.split(' - ');
    _departamentoController = TextEditingController(
      text: partes.length > 0 ? partes[0] : '',
    );
    _distritoController = TextEditingController(
      text: partes.length > 1 ? partes[1] : '',
    );
    _direccionController = TextEditingController(
      text: partes.length > 2 ? partes[2] : '',
    );
  }

  @override
  void dispose() {
    _departamentoController.dispose();
    _distritoController.dispose();
    _direccionController.dispose();
    super.dispose();
  }

  void _confirmar() {
    if (_departamentoController.text.isEmpty ||
        _distritoController.text.isEmpty ||
        _direccionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor completa todos los campos'),
        ),
      );
      return;
    }

    Navigator.of(context).pop({
      'departamento': _departamentoController.text,
      'distrito': _distritoController.text,
      'direccion': _direccionController.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    final greenColor = const Color(0xFFBACB95);
    final yellowColor = Colors.amber.shade700;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Nueva Dirección',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            // Campo Departamento
            _DireccionField(
              controller: _departamentoController,
              icon: Icons.business,
              iconColor: yellowColor,
              hint: 'Lima',
            ),
            const SizedBox(height: 16),
            // Campo Distrito
            _DireccionField(
              controller: _distritoController,
              icon: Icons.location_city,
              iconColor: yellowColor,
              hint: 'Miraflores',
            ),
            const SizedBox(height: 16),
            // Campo Dirección
            _DireccionField(
              controller: _direccionController,
              icon: Icons.home,
              iconColor: yellowColor,
              hint: 'Mz8b',
            ),
            const SizedBox(height: 24),
            // Botón Confirmar
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _confirmar,
                style: ElevatedButton.styleFrom(
                  backgroundColor: greenColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Confirmar',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
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

class _DireccionField extends StatelessWidget {
  final TextEditingController controller;
  final IconData icon;
  final Color iconColor;
  final String hint;

  const _DireccionField({
    required this.controller,
    required this.icon,
    required this.iconColor,
    required this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: iconColor, width: 2),
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hint,
              suffixIcon: const Icon(
                Icons.edit,
                color: Colors.grey,
                size: 18,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: iconColor, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

