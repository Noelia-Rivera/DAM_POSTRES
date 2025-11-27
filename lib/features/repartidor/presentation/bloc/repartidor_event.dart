part of 'repartidor_bloc.dart';

abstract class RepartidorEvent extends Equatable {
  const RepartidorEvent();

  @override
  List<Object> get props => [];
}

class LoadRepartidorInfo extends RepartidorEvent {
  final String repartidorId;

  const LoadRepartidorInfo({required this.repartidorId});

  @override
  List<Object> get props => [repartidorId];
}

class LoadPedidosAsignados extends RepartidorEvent {
  final String repartidorId;

  const LoadPedidosAsignados({required this.repartidorId});

  @override
  List<Object> get props => [repartidorId];
}

class ActualizarEstadoPedido extends RepartidorEvent {
  final String repartidorId;
  final String pedidoId;
  final String nuevoEstado;

  const ActualizarEstadoPedido({
    required this.repartidorId,
    required this.pedidoId,
    required this.nuevoEstado,
  });

  @override
  List<Object> get props => [repartidorId, pedidoId, nuevoEstado];
}

class IniciarTurno extends RepartidorEvent {
  final String repartidorId;

  const IniciarTurno({required this.repartidorId});

  @override
  List<Object> get props => [repartidorId];
}

class FinalizarTurno extends RepartidorEvent {
  final String repartidorId;

  const FinalizarTurno({required this.repartidorId});

  @override
  List<Object> get props => [repartidorId];
}

