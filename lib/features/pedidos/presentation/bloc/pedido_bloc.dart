import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/pedido.dart';
import '../../domain/usecases/get_pedidos_usecase.dart';

part 'pedido_event.dart';
part 'pedido_state.dart';

class PedidoBloc extends Bloc<PedidoEvent, PedidoState> {
  final GetPedidosUseCase getPedidosUseCase;

  PedidoBloc({required this.getPedidosUseCase}) : super(PedidoInitial()) {
    on<LoadPedidos>((event, emit) async {
      emit(PedidoLoading());
      try {
        final pedidos = await getPedidosUseCase();
        emit(PedidoLoaded(pedidos: pedidos));
      } catch (e) {
        emit(PedidoError(message: e.toString()));
      }
    });
  }
}
