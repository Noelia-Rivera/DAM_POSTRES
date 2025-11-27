part of 'admin_bloc.dart';

abstract class AdminEvent extends Equatable {
  const AdminEvent();

  @override
  List<Object?> get props => [];
}

class LoadProductos extends AdminEvent {
  final String? categoria;

  const LoadProductos({this.categoria});

  @override
  List<Object?> get props => [categoria];
}

class ChangeCategoria extends AdminEvent {
  final String? categoria;

  const ChangeCategoria(this.categoria);

  @override
  List<Object?> get props => [categoria];
}

class CreateProducto extends AdminEvent {
  final Producto producto;

  const CreateProducto(this.producto);

  @override
  List<Object> get props => [producto];
}

class UpdateProducto extends AdminEvent {
  final Producto producto;

  const UpdateProducto(this.producto);

  @override
  List<Object> get props => [producto];
}
