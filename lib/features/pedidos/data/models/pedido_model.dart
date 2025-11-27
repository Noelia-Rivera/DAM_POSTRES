import '../../domain/entities/pedido.dart';

class DetallePedidoModel {
  final int? idDetalle;
  final int idProducto;
  final String? nombreProducto;
  final int cantidad;
  final double? precioUnitario;
  final double? subtotal;

  const DetallePedidoModel({
    this.idDetalle,
    required this.idProducto,
    this.nombreProducto,
    required this.cantidad,
    this.precioUnitario,
    this.subtotal,
  });

  factory DetallePedidoModel.fromJson(Map<String, dynamic> json) {
    return DetallePedidoModel(
      idDetalle: json['idDetalle'] as int?,
      idProducto: json['idProducto'] as int? ?? 0,
      nombreProducto: json['nombreProducto'] as String?,
      cantidad: json['cantidad'] as int? ?? 1,
      precioUnitario: (json['precioUnitario'] as num?)?.toDouble(),
      subtotal: (json['subtotal'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'idProducto': idProducto,
    'cantidad': cantidad,
  };
}

class PedidoModel extends Pedido {
  final List<DetallePedidoModel> detalles;
  final String? horaEntrega;
  final int? idEstado;

  PedidoModel({
    required super.id,
    required super.nombreUsuario,
    required super.apodo,
    required super.costoTotal,
    required super.fechaPedido,
    required super.fechaEntrega,
    required super.repartidor,
    required super.direccion,
    required super.estado,
    this.detalles = const [],
    this.horaEntrega,
    this.idEstado,
  });

  factory PedidoModel.fromJson(Map<String, dynamic> json) {
    final estadoJson = json['estado'] as Map<String, dynamic>?;
    final usuarioJson = json['usuario'] as Map<String, dynamic>?;
    final repartidorJson = json['repartidor'] as Map<String, dynamic>?;
    
    return PedidoModel(
      id: (json['idPedido'] ?? json['id'])?.toString() ?? '',
      nombreUsuario: usuarioJson?['username'] as String? ?? '',
      apodo: usuarioJson?['username'] as String? ?? '',
      costoTotal: (json['total'] as num?)?.toDouble() ?? 0,
      fechaPedido: _parseDate(json['fechaPedido']),
      fechaEntrega: _parseDate(json['fechaEntrega']),
      horaEntrega: json['horaEntrega'] as String?,
      repartidor: repartidorJson?['codigo'] as String? ?? 'Sin asignar',
      direccion: json['direccion'] as String? ?? '',
      estado: estadoJson?['nombre'] as String? ?? 'PENDIENTE',
      idEstado: estadoJson?['idEstado'] as int?,
      detalles: (json['detalles'] as List?)
          ?.map((e) => DetallePedidoModel.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
    );
  }

  static DateTime _parseDate(dynamic date) {
    if (date == null) return DateTime.now();
    if (date is String) {
      return DateTime.tryParse(date) ?? DateTime.now();
    }
    return DateTime.now();
  }

  Map<String, dynamic> toCreateJson() => {
    'fechaEntrega': fechaEntrega.toIso8601String().split('T')[0],
    'horaEntrega': horaEntrega ?? '12:00',
    'total': costoTotal,
    'direccion': direccion,
    'detalles': detalles.map((d) => d.toJson()).toList(),
  };

  Map<String, dynamic> toUpdateJson() => {
    'fechaEntrega': fechaEntrega.toIso8601String().split('T')[0],
    'horaEntrega': horaEntrega ?? '12:00',
    'total': costoTotal,
    'direccion': direccion,
    if (idEstado != null) 'estado': {'idEstado': idEstado},
    'detalles': detalles.map((d) => d.toJson()).toList(),
  };
}
