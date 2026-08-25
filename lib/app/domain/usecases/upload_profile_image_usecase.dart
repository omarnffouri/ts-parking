import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../repositories/settings_repository.dart';

class UploadProfileImageUsecase {
  final ISettingsRepository repository;

  UploadProfileImageUsecase(this.repository);

  Future<Either<Failure, void>> execute(String imagePath) async {
    return await repository.uploadProfileImage(imagePath);
  }
}
