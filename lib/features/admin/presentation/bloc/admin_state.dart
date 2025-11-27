part of 'admin_bloc.dart';

abstract class AdminState extends Equatable {
  const AdminState();

  @override
  List<Object?> get props => [];
}

class AdminInitial extends AdminState {}

class AdminLoading extends AdminState {}

class AdminLoaded extends AdminState {
  final List<Producto> productos;
  final String? categoriaActual;

  const AdminLoaded({
    required this.productos,
    this.categoriaActual,
  });

  @override
  List<Object?> get props => [productos, categoriaActual];
}

class AdminError extends AdminState {
  final String message;

  const AdminError({required this.message});

  @override
  List<Object> get props => [message];
}
