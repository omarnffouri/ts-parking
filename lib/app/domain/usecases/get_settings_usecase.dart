import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../entities/settings_entity.dart';
import '../repositories/settings_repository.dart';

class GetSettingsUsecase {
  final ISettingsRepository repository;

  GetSettingsUsecase(this.repository);

  Future<Either<Failure, SettingsEntity>> execute() async {
    return await repository.getSettings();
  }
}
