part of 'repartidor_bloc.dart';

abstract class RepartidorState extends Equatable {
  const RepartidorState();

  @override
  List<Object> get props => [];
}

class RepartidorInitial extends RepartidorState {}

class RepartidorLoading extends RepartidorState {}

class RepartidorInfoLoaded extends RepartidorState {
  final Repartidor repartidor;

  const RepartidorInfoLoaded({required this.repartidor});

  @override
  List<Object> get props => [repartidor];
}

class PedidosAsignadosLoaded extends RepartidorState {
  final List<Pedido> pedidos;

  const PedidosAsignadosLoaded({required this.pedidos});

  @override
  List<Object> get props => [pedidos];
}

class RepartidorError extends RepartidorState {
  final String message;

  const RepartidorError({required this.message});

  @override
  List<Object> get props => [message];
}

