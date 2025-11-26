part of 'pedido_bloc.dart';

abstract class PedidoEvent extends Equatable {
  const PedidoEvent();

  @override
  List<Object> get props => [];
}

class LoadPedidos extends PedidoEvent {}
