import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import 'auth_service.dart';

class NotificacionPedido {
  final String tipo;
  final String mensaje;
  final int timestamp;
  final Map<String, dynamic>? pedido;

  NotificacionPedido({
    required this.tipo,
    required this.mensaje,
    required this.timestamp,
    this.pedido,
  });

  factory NotificacionPedido.fromJson(Map<String, dynamic> json) {
    return NotificacionPedido(
      tipo: json['tipo'] as String? ?? '',
      mensaje: json['mensaje'] as String? ?? '',
      timestamp: json['timestamp'] as int? ?? 0,
      pedido: json['pedido'] as Map<String, dynamic>?,
    );
  }
}

/// Servicio de notificaciones usando HTTP polling
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final _notificacionController = StreamController<NotificacionPedido>.broadcast();
  final AuthService _authService = AuthService();
  Timer? _pollingTimer;
  int? _userId;
  int? _repartidorId;
  String? _userRole;
  bool _isListening = false;

  Stream<NotificacionPedido> get notificacionStream => _notificacionController.stream;

  /// Iniciar escucha de notificaciones según el rol del usuario
  Future<void> iniciar() async {
    if (_isListening) return;

    final user = await _authService.getUser();
    if (user == null) return;

    _userId = user.idUsuario;
    _userRole = user.roles.isNotEmpty ? user.roles.first.toUpperCase() : null;

    _isListening = true;

    // Polling cada 5 segundos
    _pollingTimer = Timer.periodic(const Duration(seconds: 5), (_) async {
      await _obtenerNotificaciones();
    });

    // Obtener notificaciones iniciales
    await _obtenerNotificaciones();
  }

  /// Configurar ID del repartidor (llamar desde la pantalla del repartidor)
  void setRepartidorId(int id) {
    _repartidorId = id;
  }

  Future<void> _obtenerNotificaciones() async {
    if (_userId == null || _userRole == null) return;

    try {
      String endpoint;
      if (_userRole == 'CLIENTE') {
        endpoint = '${ApiConfig.baseUrl}/api/v1/notificaciones/cliente/$_userId';
      } else if (_userRole == 'REPARTIDOR') {
        // Para repartidor usamos el userId también (el backend lo maneja)
        final id = _repartidorId ?? _userId;
        endpoint = '${ApiConfig.baseUrl}/api/v1/notificaciones/repartidor/$id';
      } else {
        return;
      }

      final response = await http.get(Uri.parse(endpoint));

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        final data = jsonDecode(response.body);
        if (data is List) {
          for (var item in data) {
            final notificacion = NotificacionPedido.fromJson(item);
            _notificacionController.add(notificacion);
          }
        }
      }
    } catch (e) {
      // Error silencioso
    }
  }

  /// Detener escucha
  void detener() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
    _isListening = false;
  }

  void dispose() {
    detener();
    _notificacionController.close();
  }

  /// Mostrar notificación como SnackBar
  static void mostrarNotificacion(BuildContext context, NotificacionPedido notificacion) {
    final color = _getColorPorTipo(notificacion.tipo);
    final icon = _getIconPorTipo(notificacion.tipo);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                notificacion.mensaje,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: color,
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  static Color _getColorPorTipo(String tipo) {
    switch (tipo) {
      case 'PEDIDO_ACEPTADO':
        return Colors.blue;
      case 'EN_PREPARACION':
        return Colors.orange;
      case 'LISTO_PARA_ENTREGA':
        return Colors.teal;
      case 'PEDIDO_ASIGNADO':
        return Colors.indigo;
      case 'ENTREGA_INICIADA':
        return Colors.purple;
      case 'PEDIDO_ENTREGADO':
        return Colors.green;
      case 'PEDIDO_CANCELADO':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  static IconData _getIconPorTipo(String tipo) {
    switch (tipo) {
      case 'PEDIDO_ACEPTADO':
        return Icons.check_circle;
      case 'EN_PREPARACION':
        return Icons.restaurant;
      case 'LISTO_PARA_ENTREGA':
        return Icons.inventory;
      case 'PEDIDO_ASIGNADO':
        return Icons.assignment_ind;
      case 'ENTREGA_INICIADA':
        return Icons.delivery_dining;
      case 'PEDIDO_ENTREGADO':
        return Icons.done_all;
      case 'PEDIDO_CANCELADO':
        return Icons.cancel;
      default:
        return Icons.notifications;
    }
  }
}
