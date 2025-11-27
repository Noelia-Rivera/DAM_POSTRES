import '../repositories/repartidor_repository.dart';

class GestionarTurnoUseCase {
  final RepartidorRepository repository;

  GestionarTurnoUseCase(this.repository);

  Future<void> iniciarTurno(String repartidorId) async {
    return await repository.iniciarTurno(repartidorId);
  }

  Future<void> finalizarTurno(String repartidorId) async {
    return await repository.finalizarTurno(repartidorId);
  }
}

