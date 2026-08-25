import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../../data/models/paginated_response.dart';
import '../entities/yard_entity.dart';
import '../repositories/yard_repository.dart';

class GetYardsUsecase {
  final IYardRepository repository;

  GetYardsUsecase(this.repository);

  Future<Either<Failure, PaginatedResponse<YardEntity>>> execute({
    int page = 1,
    int limit = 20,
  }) async {
    return await repository.getYards(page: page, limit: limit);
  }
}
