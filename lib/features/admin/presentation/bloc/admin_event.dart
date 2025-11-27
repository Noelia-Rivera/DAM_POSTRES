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

class CreateProductoWithImage extends AdminEvent {
  final Producto producto;
  final File imageFile;

  const CreateProductoWithImage(this.producto, this.imageFile);

  @override
  List<Object> get props => [producto, imageFile];
}

class UpdateProducto extends AdminEvent {
  final Producto producto;

  const UpdateProducto(this.producto);

  @override
  List<Object> get props => [producto];
}

class DeleteProducto extends AdminEvent {
  final String productoId;

  const DeleteProducto(this.productoId);

  @override
  List<Object> get props => [productoId];
}
