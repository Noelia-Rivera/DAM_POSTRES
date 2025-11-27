import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../../core/services/tracking_service.dart';

class TrackingPedidoScreen extends StatefulWidget {
  final String pedidoId;
  final String direccionEntrega;

  const TrackingPedidoScreen({
    super.key,
    required this.pedidoId,
    this.direccionEntrega = '',
  });

  @override
  State<TrackingPedidoScreen> createState() => _TrackingPedidoScreenState();
}

class _TrackingPedidoScreenState extends State<TrackingPedidoScreen> {
  final TrackingService _trackingService = TrackingService();
  final MapController _mapController = MapController();
  StreamSubscription<UbicacionRepartidor>? _ubicacionSubscription;

  // Ubicación inicial (Lima, Perú - cambiar según tu ubicación)
  static const LatLng _ubicacionInicial = LatLng(-12.0464, -77.0428);

  LatLng? _ubicacionRepartidor;
  bool _isConnected = false;
  String _estadoConexion = 'Conectando...';

  @override
  void initState() {
    super.initState();
    _iniciarTracking();
  }

  void _iniciarTracking() {
    final pedidoId = int.tryParse(widget.pedidoId);
    if (pedidoId == null) return;

    _trackingService.conectar(pedidoId);

    _ubicacionSubscription = _trackingService.ubicacionStream.listen(
      (ubicacion) {
        setState(() {
          _isConnected = true;
          _estadoConexion = 'En tiempo real';
          _ubicacionRepartidor = LatLng(ubicacion.latitud, ubicacion.longitud);
        });

        // Mover cámara a la ubicación del repartidor
        _mapController.move(_ubicacionRepartidor!, 16);
      },
      onError: (error) {
        setState(() {
          _isConnected = false;
          _estadoConexion = 'Error de conexión';
        });
      },
    );

    // Verificar conexión después de un tiempo
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && !_isConnected) {
        setState(() {
          _estadoConexion = 'Esperando ubicación del repartidor...';
        });
      }
    });
  }

  @override
  void dispose() {
    _ubicacionSubscription?.cancel();
    _trackingService.dispose();
    super.dispose();
  }

  List<Marker> _buildMarkers() {
    final markers = <Marker>[];

    // Marcador del repartidor
    if (_ubicacionRepartidor != null) {
      markers.add(
        Marker(
          point: _ubicacionRepartidor!,
          width: 50,
          height: 50,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.delivery_dining,
              color: Colors.white,
              size: 28,
            ),
          ),
        ),
      );
    }

    // Marcador de destino
    markers.add(
      Marker(
        point: _ubicacionInicial,
        width: 50,
        height: 50,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.green,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Icon(
            Icons.home,
            color: Colors.white,
            size: 28,
          ),
        ),
      ),
    );

    return markers;
  }

  @override
  Widget build(BuildContext context) {
    final pinkColor = const Color(0xFFD7B3AF);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: pinkColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Seguimiento Pedido #${widget.pedidoId}',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          // Estado de conexión
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            color: _isConnected ? Colors.green.shade100 : Colors.orange.shade100,
            child: Row(
              children: [
                Icon(
                  _isConnected ? Icons.wifi : Icons.wifi_off,
                  size: 18,
                  color: _isConnected ? Colors.green : Colors.orange,
                ),
                const SizedBox(width: 8),
                Text(
                  _estadoConexion,
                  style: TextStyle(
                    color: _isConnected ? Colors.green.shade800 : Colors.orange.shade800,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // Mapa OpenStreetMap (GRATIS)
          Expanded(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _ubicacionRepartidor ?? _ubicacionInicial,
                initialZoom: 15,
              ),
              children: [
                // Capa de tiles de OpenStreetMap
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.postres.app',
                ),
                // Marcadores
                MarkerLayer(markers: _buildMarkers()),
              ],
            ),
          ),

          // Info del pedido
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: pinkColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.delivery_dining, color: pinkColor, size: 28),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Tu pedido está en camino',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.direccionEntrega.isNotEmpty
                                ? widget.direccionEntrega
                                : 'Dirección de entrega',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Timeline de estados
                _buildTimeline(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline() {
    return Row(
      children: [
        _buildTimelineItem('Preparando', true, true),
        _buildTimelineLine(true),
        _buildTimelineItem('En camino', _isConnected, _isConnected),
        _buildTimelineLine(false),
        _buildTimelineItem('Entregado', false, false),
      ],
    );
  }

  Widget _buildTimelineItem(String label, bool isActive, bool isCompleted) {
    final pinkColor = const Color(0xFFD7B3AF);

    return Column(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCompleted ? pinkColor : Colors.grey.shade300,
            border: Border.all(
              color: isActive ? pinkColor : Colors.grey.shade300,
              width: 2,
            ),
          ),
          child: isCompleted
              ? const Icon(Icons.check, size: 14, color: Colors.white)
              : null,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: isActive ? pinkColor : Colors.grey,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineLine(bool isCompleted) {
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.only(bottom: 20),
        color: isCompleted ? const Color(0xFFD7B3AF) : Colors.grey.shade300,
      ),
    );
  }
}
