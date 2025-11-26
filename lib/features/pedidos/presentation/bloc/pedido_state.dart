part of 'pedido_bloc.dart';

abstract class PedidoState extends Equatable {
  const PedidoState();
  
  @override
  List<Object> get props => [];
}

class PedidoInitial extends PedidoState {}

class PedidoLoading extends PedidoState {}

class PedidoLoaded extends PedidoState {
  final List<Pedido> pedidos;
  
  const PedidoLoaded({required this.pedidos});
  
  @override
  List<Object> get props => [pedidos];
}

class PedidoError extends PedidoState {
  final String message;
  
  const PedidoError({required this.message});
  
  @override
  List<Object> get props => [message];
}
