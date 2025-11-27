import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class UbicacionRepartidor {
  final int pedidoId;
  final int repartidorId;
  final double latitud;
  final double longitud;
  final String timestamp;

  UbicacionRepartidor({
    required this.pedidoId,
    required this.repartidorId,
    required this.latitud,
    required this.longitud,
    required this.timestamp,
  });

  factory UbicacionRepartidor.fromJson(Map<String, dynamic> json) {
    return UbicacionRepartidor(
      pedidoId: json['pedidoId'] as int? ?? 0,
      repartidorId: json['repartidorId'] as int? ?? 0,
      latitud: (json['latitud'] as num?)?.toDouble() ?? 0,
      longitud: (json['longitud'] as num?)?.toDouble() ?? 0,
      timestamp: json['timestamp'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'pedidoId': pedidoId,
        'repartidorId': repartidorId,
        'latitud': latitud,
        'longitud': longitud,
        'timestamp': timestamp,
      };
}

/// Servicio de tracking usando HTTP polling (más compatible con web)
class TrackingService {
  final _ubicacionController = StreamController<UbicacionRepartidor>.broadcast();
  Timer? _pollingTimer;
  int? _pedidoId;

  Stream<UbicacionRepartidor> get ubicacionStream => _ubicacionController.stream;

  bool _isConnected = false;
  bool get isConnected => _isConnected;

  /// Conectar y empezar a recibir actualizaciones de ubicación
  void conectar(int pedidoId) {
    _pedidoId = pedidoId;
    _isConnected = true;

    // Polling cada 3 segundos para obtener la ubicación
    _pollingTimer = Timer.periodic(const Duration(seconds: 3), (_) async {
      await _obtenerUbicacion();
    });

    // Obtener ubicación inicial
    _obtenerUbicacion();
  }

  Future<void> _obtenerUbicacion() async {
    if (_pedidoId == null) return;

    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/api/v1/tracking/pedido/$_pedidoId'),
      );

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        final data = jsonDecode(response.body);
        if (data != null) {
          final ubicacion = UbicacionRepartidor.fromJson(data);
          _ubicacionController.add(ubicacion);
        }
      }
    } catch (e) {
      // Error silencioso - el repartidor aún no ha enviado ubicación
    }
  }

  /// Enviar ubicación (usado por el repartidor)
  Future<void> enviarUbicacion(UbicacionRepartidor ubicacion) async {
    try {
      await http.post(
        Uri.parse('${ApiConfig.baseUrl}/api/v1/tracking/actualizar'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(ubicacion.toJson()),
      );
    } catch (e) {
      // Error al enviar ubicación
    }
  }

  /// Desconectar
  void desconectar() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
    _isConnected = false;
    _pedidoId = null;
  }

  void dispose() {
    desconectar();
    _ubicacionController.close();
  }
}
