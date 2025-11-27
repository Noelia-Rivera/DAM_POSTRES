import '../entities/repartidor.dart';
import '../repositories/repartidor_repository.dart';

class GetRepartidorInfoUseCase {
  final RepartidorRepository repository;

  GetRepartidorInfoUseCase(this.repository);

  Future<Repartidor> call(String repartidorId) async {
    return await repository.getRepartidorInfo(repartidorId);
  }
}

