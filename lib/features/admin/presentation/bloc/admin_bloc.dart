import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/producto.dart';
import '../../domain/usecases/get_productos_usecase.dart';
import '../../domain/usecases/create_producto_usecase.dart';
import '../../domain/usecases/update_producto_usecase.dart';

part 'admin_event.dart';
part 'admin_state.dart';

class AdminBloc extends Bloc<AdminEvent, AdminState> {
  final GetProductosUseCase getProductosUseCase;
  final CreateProductoUseCase createProductoUseCase;
  final UpdateProductoUseCase updateProductoUseCase;

  AdminBloc({
    required this.getProductosUseCase,
    required this.createProductoUseCase,
    required this.updateProductoUseCase,
  }) : super(AdminInitial()) {
    on<LoadProductos>((event, emit) async {
      emit(AdminLoading());
      try {
        final productos = await getProductosUseCase(categoria: event.categoria);
        emit(AdminLoaded(productos: productos, categoriaActual: event.categoria));
      } catch (e) {
        emit(AdminError(message: e.toString()));
      }
    });

    on<ChangeCategoria>((event, emit) async {
      emit(AdminLoading());
      try {
        final productos = await getProductosUseCase(categoria: event.categoria);
        emit(AdminLoaded(productos: productos, categoriaActual: event.categoria));
      } catch (e) {
        emit(AdminError(message: e.toString()));
      }
    });

    on<CreateProducto>((event, emit) async {
      emit(AdminLoading());
      try {
        await createProductoUseCase(event.producto);
        final productos = await getProductosUseCase();
        emit(AdminLoaded(productos: productos));
      } catch (e) {
        emit(AdminError(message: e.toString()));
      }
    });

    on<UpdateProducto>((event, emit) async {
      emit(AdminLoading());
      try {
        await updateProductoUseCase(event.producto);
        final productos = await getProductosUseCase();
        emit(AdminLoaded(productos: productos));
      } catch (e) {
        emit(AdminError(message: e.toString()));
      }
    });
  }
}
