import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/categoria.dart';
import '../../domain/usecases/get_categorias_usecase.dart';
import '../../domain/usecases/create_categoria_usecase.dart';
import '../../domain/usecases/update_categoria_usecase.dart';
import '../../domain/usecases/delete_categoria_usecase.dart';

part 'categoria_event.dart';
part 'categoria_state.dart';

class CategoriaBloc extends Bloc<CategoriaEvent, CategoriaState> {
  final GetCategoriasUseCase getCategoriasUseCase;
  final CreateCategoriaUseCase createCategoriaUseCase;
  final UpdateCategoriaUseCase updateCategoriaUseCase;
  final DeleteCategoriaUseCase deleteCategoriaUseCase;

  CategoriaBloc({
    required this.getCategoriasUseCase,
    required this.createCategoriaUseCase,
    required this.updateCategoriaUseCase,
    required this.deleteCategoriaUseCase,
  }) : super(CategoriaInitial()) {
    on<LoadCategorias>((event, emit) async {
      emit(CategoriaLoading());
      try {
        final categorias = await getCategoriasUseCase();
        emit(CategoriaLoaded(categorias: categorias));
      } catch (e) {
        emit(CategoriaError(message: e.toString()));
      }
    });

    on<CreateCategoria>((event, emit) async {
      emit(CategoriaLoading());
      try {
        await createCategoriaUseCase(event.categoria);
        final categorias = await getCategoriasUseCase();
        emit(CategoriaLoaded(categorias: categorias));
      } catch (e) {
        emit(CategoriaError(message: e.toString()));
      }
    });

    on<UpdateCategoria>((event, emit) async {
      emit(CategoriaLoading());
      try {
        await updateCategoriaUseCase(event.categoria);
        final categorias = await getCategoriasUseCase();
        emit(CategoriaLoaded(categorias: categorias));
      } catch (e) {
        emit(CategoriaError(message: e.toString()));
      }
    });

    on<DeleteCategoria>((event, emit) async {
      emit(CategoriaLoading());
      try {
        await deleteCategoriaUseCase(event.id);
        final categorias = await getCategoriasUseCase();
        emit(CategoriaLoaded(categorias: categorias));
      } catch (e) {
        emit(CategoriaError(message: e.toString()));
      }
    });
  }
}
