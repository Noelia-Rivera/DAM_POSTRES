import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/repartidor.dart';
import '../../domain/usecases/get_repartidor_info_usecase.dart';
import '../../domain/usecases/get_pedidos_asignados_usecase.dart';
import '../../domain/usecases/actualizar_estado_pedido_usecase.dart';
import '../../domain/usecases/gestionar_turno_usecase.dart';
import '../../../pedidos/domain/entities/pedido.dart';

part 'repartidor_event.dart';
part 'repartidor_state.dart';

class RepartidorBloc extends Bloc<RepartidorEvent, RepartidorState> {
  final GetRepartidorInfoUseCase getRepartidorInfoUseCase;
  final GetPedidosAsignadosUseCase getPedidosAsignadosUseCase;
  final ActualizarEstadoPedidoUseCase actualizarEstadoPedidoUseCase;
  final GestionarTurnoUseCase gestionarTurnoUseCase;

  RepartidorBloc({
    required this.getRepartidorInfoUseCase,
    required this.getPedidosAsignadosUseCase,
    required this.actualizarEstadoPedidoUseCase,
    required this.gestionarTurnoUseCase,
  }) : super(RepartidorInitial()) {
    on<LoadRepartidorInfo>(_onLoadRepartidorInfo);
    on<LoadPedidosAsignados>(_onLoadPedidosAsignados);
    on<ActualizarEstadoPedido>(_onActualizarEstadoPedido);
    on<IniciarTurno>(_onIniciarTurno);
    on<FinalizarTurno>(_onFinalizarTurno);
  }

  Future<void> _onLoadRepartidorInfo(
    LoadRepartidorInfo event,
    Emitter<RepartidorState> emit,
  ) async {
    emit(RepartidorLoading());
    try {
      final repartidor = await getRepartidorInfoUseCase(event.repartidorId);
      emit(RepartidorInfoLoaded(repartidor: repartidor));
    } catch (e) {
      emit(RepartidorError(message: e.toString()));
    }
  }

  Future<void> _onLoadPedidosAsignados(
    LoadPedidosAsignados event,
    Emitter<RepartidorState> emit,
  ) async {
    emit(RepartidorLoading());
    try {
      final pedidos = await getPedidosAsignadosUseCase(event.repartidorId);
      emit(PedidosAsignadosLoaded(pedidos: pedidos));
    } catch (e) {
      emit(RepartidorError(message: e.toString()));
    }
  }

  Future<void> _onActualizarEstadoPedido(
    ActualizarEstadoPedido event,
    Emitter<RepartidorState> emit,
  ) async {
    try {
      await actualizarEstadoPedidoUseCase(event.pedidoId, event.nuevoEstado);
      // Recargar pedidos después de actualizar
      add(LoadPedidosAsignados(repartidorId: event.repartidorId));
    } catch (e) {
      emit(RepartidorError(message: e.toString()));
    }
  }

  Future<void> _onIniciarTurno(
    IniciarTurno event,
    Emitter<RepartidorState> emit,
  ) async {
    try {
      await gestionarTurnoUseCase.iniciarTurno(event.repartidorId);
      // Recargar info del repartidor
      add(LoadRepartidorInfo(repartidorId: event.repartidorId));
    } catch (e) {
      emit(RepartidorError(message: e.toString()));
    }
  }

  Future<void> _onFinalizarTurno(
    FinalizarTurno event,
    Emitter<RepartidorState> emit,
  ) async {
    try {
      await gestionarTurnoUseCase.finalizarTurno(event.repartidorId);
      // Recargar info del repartidor
      add(LoadRepartidorInfo(repartidorId: event.repartidorId));
    } catch (e) {
      emit(RepartidorError(message: e.toString()));
    }
  }
}

