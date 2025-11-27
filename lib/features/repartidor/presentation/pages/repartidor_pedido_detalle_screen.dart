import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../core/services/api_services.dart';
import '../../../../core/services/tracking_service.dart';
import '../../../pedidos/domain/entities/pedido.dart';

class RepartidorPedidoDetalleScreen extends StatefulWidget {
  final Pedido pedido;
  const RepartidorPedidoDetalleScreen({super.key, required this.pedido});

  @override
  State<RepartidorPedidoDetalleScreen> createState() => _RepartidorPedidoDetalleScreenState();
}

class _RepartidorPedidoDetalleScreenState extends State<RepartidorPedidoDetalleScreen> {
  bool _isLoading = false;
  late String _estadoActual;
  
  // Tracking
  final TrackingService _trackingService = TrackingService();
  Timer? _locationTimer;
  bool _isTracking = false;
  String _trackingStatus = '';

  @override
  void initState() {
    super.initState();
    _estadoActual = widget.pedido.estado;
    
    // Si ya está en camino, iniciar tracking automáticamente
    if (_estadoActual.toUpperCase() == 'EN_CAMINO') {
      _iniciarTracking();
    }
  }

  @override
  void dispose() {
    _detenerTracking();
    super.dispose();
  }

  Future<void> _iniciarTracking() async {
    // Verificar permisos de ubicación
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showError('Permisos de ubicación denegados');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _showError('Permisos de ubicación permanentemente denegados');
      return;
    }

    // Conectar al WebSocket
    final pedidoId = int.tryParse(widget.pedido.id);
    if (pedidoId != null) {
      _trackingService.conectar(pedidoId);
    }

    setState(() {
      _isTracking = true;
      _trackingStatus = 'Compartiendo ubicación...';
    });

    // Enviar ubicación cada 5 segundos
    _locationTimer = Timer.periodic(const Duration(seconds: 5), (_) async {
      await _enviarUbicacion();
    });

    // Enviar ubicación inicial
    await _enviarUbicacion();
  }

  Future<void> _enviarUbicacion() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final pedidoId = int.tryParse(widget.pedido.id) ?? 0;
      
      final ubicacion = UbicacionRepartidor(
        pedidoId: pedidoId,
        repartidorId: 0, // Se puede obtener del usuario logueado
        latitud: position.latitude,
        longitud: position.longitude,
        timestamp: DateTime.now().toIso8601String(),
      );

      _trackingService.enviarUbicacion(ubicacion);
      
      if (mounted) {
        setState(() {
          _trackingStatus = 'Ubicación actualizada';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _trackingStatus = 'Error al obtener ubicación';
        });
      }
    }
  }

  void _detenerTracking() {
    _locationTimer?.cancel();
    _trackingService.desconectar();
    _isTracking = false;
  }

  String _formatearFecha(DateTime fecha) => '${fecha.day}/${fecha.month}/${fecha.year}';

  Future<void> _iniciarEntrega() async {
    setState(() => _isLoading = true);
    try {
      await ApiServices.pedidoDataSource.iniciarEntrega(widget.pedido.id);
      setState(() => _estadoActual = 'EN_CAMINO');
      _showSuccess('Entrega iniciada');
      
      // Iniciar tracking de ubicación
      await _iniciarTracking();
    } catch (e) {
      _showError('Error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _marcarEntregado() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar Entrega'),
        content: const Text('¿Confirmar que el pedido fue entregado?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Confirmar', style: TextStyle(color: Colors.green))),
        ],
      ),
    );
    if (confirm != true) return;

    setState(() => _isLoading = true);
    try {
      // Detener tracking antes de marcar como entregado
      _detenerTracking();
      
      await ApiServices.pedidoDataSource.marcarEntregado(widget.pedido.id);
      setState(() => _estadoActual = 'ENTREGADO');
      _showSuccess('¡Pedido entregado exitosamente!');
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) context.pop();
      });
    } catch (e) {
      _showError('Error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSuccess(String msg) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.green));
  void _showError(String msg) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.red));

  Color _getEstadoColor(String estado) {
    switch (estado.toUpperCase()) {
      case 'LISTO_PARA_ENTREGA': return Colors.teal;
      case 'EN_CAMINO': return Colors.indigo;
      case 'ENTREGADO': return Colors.green;
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final pinkColor = const Color(0xFFD7B3AF);
    final greenColor = const Color(0xFFBACB95);
    final estado = _estadoActual.toUpperCase();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: pinkColor,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => context.pop()),
        title: const Text('Detalle del Pedido', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Card principal
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: pinkColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 4))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Pedido #${widget.pedido.id}', style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(color: _getEstadoColor(_estadoActual), borderRadius: BorderRadius.circular(20)),
                        child: Text(_estadoActual.replaceAll('_', ' '), style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _CardInfo(label: 'Cliente', value: widget.pedido.nombreUsuario, icon: Icons.person),
                  const SizedBox(height: 12),
                  _CardInfo(label: 'Total', value: 'S/. ${widget.pedido.costoTotal.toStringAsFixed(2)}', icon: Icons.attach_money),
                ],
              ),
            ),
            // Información detallada
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _InfoRow(icon: Icons.calendar_today, label: 'Fecha de pedido', value: _formatearFecha(widget.pedido.fechaPedido)),
                  const SizedBox(height: 12),
                  _InfoRow(icon: Icons.event_available, label: 'Fecha de entrega', value: _formatearFecha(widget.pedido.fechaEntrega)),
                  const SizedBox(height: 12),
                  _InfoRow(icon: Icons.location_on, label: 'Dirección', value: widget.pedido.direccion),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // Botones de acción
            if (estado != 'ENTREGADO')
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    if (estado == 'LISTO_PARA_ENTREGA')
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton.icon(
                          onPressed: _isLoading ? null : _iniciarEntrega,
                          icon: _isLoading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Icon(Icons.delivery_dining),
                          label: const Text('Iniciar Entrega', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                        ),
                      ),
                    if (estado == 'EN_CAMINO') ...[
                      // Indicador de tracking
                      Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: _isTracking ? Colors.green.shade50 : Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: _isTracking ? Colors.green : Colors.orange),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              _isTracking ? Icons.location_on : Icons.location_off,
                              color: _isTracking ? Colors.green : Colors.orange,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _isTracking ? 'Tracking activo' : 'Tracking inactivo',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: _isTracking ? Colors.green.shade800 : Colors.orange.shade800,
                                    ),
                                  ),
                                  Text(
                                    _trackingStatus.isNotEmpty ? _trackingStatus : 'El cliente puede ver tu ubicación',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: _isTracking ? Colors.green.shade600 : Colors.orange.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (!_isTracking)
                              TextButton(
                                onPressed: _iniciarTracking,
                                child: const Text('Activar'),
                              ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton.icon(
                          onPressed: _isLoading ? null : _marcarEntregado,
                          icon: _isLoading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Icon(Icons.check_circle),
                          label: const Text('Marcar como Entregado', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(backgroundColor: greenColor, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: OutlinedButton.icon(
                          onPressed: () => _abrirMapa(),
                          icon: const Icon(Icons.map),
                          label: const Text('Ver Ruta', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          style: OutlinedButton.styleFrom(foregroundColor: pinkColor, side: BorderSide(color: pinkColor, width: 2), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            if (estado == 'ENTREGADO')
              Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.green)),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle, color: Colors.green, size: 32),
                      SizedBox(width: 12),
                      Text('Pedido Entregado', style: TextStyle(color: Colors.green, fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _abrirMapa() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Abriendo mapa de ruta...')));
  }
}

class _CardInfo extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  const _CardInfo({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.white70, size: 20),
        const SizedBox(width: 8),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
        ]),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final pinkColor = const Color(0xFFD7B3AF);
    return Row(
      children: [
        Container(
          width: 48, height: 48,
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.shade300)),
          child: Icon(icon, color: Colors.black87, size: 24),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(color: pinkColor.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 4),
              Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87)),
            ]),
          ),
        ),
      ],
    );
  }
}
