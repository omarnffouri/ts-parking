import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../../data/models/paginated_response.dart';
import '../entities/slot_entity.dart';
import '../repositories/yard_repository.dart';

class GetYardSlotsUsecase {
  final IYardRepository repository;

  GetYardSlotsUsecase(this.repository);

  Future<Either<Failure, PaginatedResponse<SlotEntity>>> execute({
    required String yardId,
    int page = 1,
    int limit = 500,
  }) async {
    return await repository.getYardSlots(
      yardId: yardId,
      page: page,
      limit: limit,
    );
  }
}
