import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/services/api_services.dart';
import '../../../pedidos/data/models/pedido_model.dart';
import '../providers/carrito_provider.dart';

class CrearPedidoScreen extends StatefulWidget {
  const CrearPedidoScreen({super.key});

  @override
  State<CrearPedidoScreen> createState() => _CrearPedidoScreenState();
}

class _CrearPedidoScreenState extends State<CrearPedidoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _direccionController = TextEditingController();
  DateTime _fechaEntrega = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _horaEntrega = const TimeOfDay(hour: 12, minute: 0);
  bool _isLoading = false;

  @override
  void dispose() {
    _direccionController.dispose();
    super.dispose();
  }

  Future<void> _seleccionarFecha() async {
    final fecha = await showDatePicker(
      context: context,
      initialDate: _fechaEntrega,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (fecha != null) {
      setState(() => _fechaEntrega = fecha);
    }
  }

  Future<void> _seleccionarHora() async {
    final hora = await showTimePicker(
      context: context,
      initialTime: _horaEntrega,
    );
    if (hora != null) {
      setState(() => _horaEntrega = hora);
    }
  }

  Future<void> _crearPedido() async {
    if (!_formKey.currentState!.validate()) return;

    final carrito = context.read<CarritoProvider>();
    if (carrito.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El carrito está vacío')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final detalles = carrito.items.map((item) => DetallePedidoModel(
        idProducto: int.parse(item.producto.id),
        cantidad: item.cantidad,
      )).toList();

      final horaStr = '${_horaEntrega.hour.toString().padLeft(2, '0')}:${_horaEntrega.minute.toString().padLeft(2, '0')}';

      final pedido = PedidoModel(
        id: '',
        nombreUsuario: '',
        apodo: '',
        costoTotal: carrito.total,
        fechaPedido: DateTime.now(),
        fechaEntrega: _fechaEntrega,
        horaEntrega: horaStr,
        repartidor: '',
        direccion: _direccionController.text.trim(),
        estado: 'PENDIENTE',
        detalles: detalles,
      );

      await ApiServices.pedidoDataSource.createPedidoCliente(pedido);

      carrito.limpiarCarrito();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('¡Pedido creado exitosamente!'),
            backgroundColor: Colors.green,
          ),
        );
        context.go('/cliente');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al crear pedido: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final pinkColor = const Color(0xFFD7B3AF);
    final carrito = context.watch<CarritoProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: pinkColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: const Text('Confirmar Pedido', style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Resumen del pedido
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: pinkColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Resumen del Pedido',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    ...carrito.items.map((item) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              '${item.cantidad}x ${item.producto.nombre}',
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text('S/. ${item.subtotal.toStringAsFixed(2)}'),
                        ],
                      ),
                    )),
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Text(
                          'S/. ${carrito.total.toStringAsFixed(2)}',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: pinkColor),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Dirección
              const Text('Dirección de entrega', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _direccionController,
                decoration: InputDecoration(
                  hintText: 'Ingresa tu dirección completa',
                  prefixIcon: const Icon(Icons.location_on),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: pinkColor, width: 2),
                  ),
                ),
                maxLines: 2,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor ingresa una dirección';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Fecha de entrega
              const Text('Fecha de entrega', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              InkWell(
                onTap: _seleccionarFecha,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today),
                      const SizedBox(width: 12),
                      Text(
                        '${_fechaEntrega.day}/${_fechaEntrega.month}/${_fechaEntrega.year}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const Spacer(),
                      Icon(Icons.arrow_drop_down, color: pinkColor),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Hora de entrega
              const Text('Hora de entrega', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              InkWell(
                onTap: _seleccionarHora,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.access_time),
                      const SizedBox(width: 12),
                      Text(
                        _horaEntrega.format(context),
                        style: const TextStyle(fontSize: 16),
                      ),
                      const Spacer(),
                      Icon(Icons.arrow_drop_down, color: pinkColor),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Botón crear pedido
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _crearPedido,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: pinkColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Confirmar Pedido',
                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
