import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/producto.dart';
import '../../domain/usecases/get_productos_usecase.dart';
import '../../domain/usecases/create_producto_usecase.dart';
import '../../domain/usecases/update_producto_usecase.dart';
import '../../domain/repositories/producto_repository.dart';

part 'admin_event.dart';
part 'admin_state.dart';

class AdminBloc extends Bloc<AdminEvent, AdminState> {
  final GetProductosUseCase getProductosUseCase;
  final CreateProductoUseCase createProductoUseCase;
  final UpdateProductoUseCase updateProductoUseCase;
  final ProductoRepository? productoRepository;

  AdminBloc({
    required this.getProductosUseCase,
    required this.createProductoUseCase,
    required this.updateProductoUseCase,
    this.productoRepository,
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

    on<CreateProductoWithImage>((event, emit) async {
      emit(AdminLoading());
      try {
        if (productoRepository != null) {
          await productoRepository!.createProductoWithImage(event.producto, event.imageFile);
        } else {
          throw Exception('ProductoRepository no está disponible');
        }
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

    on<DeleteProducto>((event, emit) async {
      emit(AdminLoading());
      try {
        if (productoRepository != null) {
          await productoRepository!.deleteProducto(event.productoId);
        }
        final productos = await getProductosUseCase();
        emit(AdminLoaded(productos: productos));
      } catch (e) {
        emit(AdminError(message: e.toString()));
      }
    });
  }
}
