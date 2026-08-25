import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../entities/settings_entity.dart';

abstract class ISettingsRepository {
  Future<Either<Failure, SettingsEntity>> getSettings();
  Future<Either<Failure, void>> uploadProfileImage(String imagePath);
}
