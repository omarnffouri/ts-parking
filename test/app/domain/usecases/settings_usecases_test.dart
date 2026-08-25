import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:ts_parking/app/core/errors/failures.dart';
import 'package:ts_parking/app/domain/entities/settings_entity.dart';
import 'package:ts_parking/app/domain/usecases/get_settings_usecase.dart';
import 'package:ts_parking/app/domain/usecases/upload_profile_image_usecase.dart';

import '../../../helpers/mocks.mocks.dart';

void main() {
  group('GetSettingsUsecase', () {
    late MockISettingsRepository mockRepo;
    late GetSettingsUsecase usecase;

    setUp(() {
      mockRepo = MockISettingsRepository();
      usecase = GetSettingsUsecase(mockRepo);
    });

    test('delegates to repository and returns settings', () async {
      const settings = SettingsEntity(
        currencyCode: 'USD',
        discountRate: 10.0,
        taxRate: 5.0,
        isTaxInclusive: false,
        otpEnabled: true,
      );
      when(
        mockRepo.getSettings(),
      ).thenAnswer((_) async => const Right(settings));

      final result = await usecase.execute();
      result.fold(
        (_) => fail('expected Right'),
        (data) => expect(data.currencyCode, 'USD'),
      );
    });

    test('returns failure from repository', () async {
      when(
        mockRepo.getSettings(),
      ).thenAnswer((_) async => const Left(ServerFailure('fail')));

      final result = await usecase.execute();
      expect(result, const Left(ServerFailure('fail')));
    });
  });

  group('UploadProfileImageUsecase', () {
    late MockISettingsRepository mockRepo;
    late UploadProfileImageUsecase usecase;

    setUp(() {
      mockRepo = MockISettingsRepository();
      usecase = UploadProfileImageUsecase(mockRepo);
    });

    test('delegates to repository', () async {
      when(
        mockRepo.uploadProfileImage('/path/img.jpg'),
      ).thenAnswer((_) async => const Right(null));

      final result = await usecase.execute('/path/img.jpg');
      expect(result.isRight(), isTrue);
      verify(mockRepo.uploadProfileImage('/path/img.jpg')).called(1);
    });

    test('returns failure from repository', () async {
      when(
        mockRepo.uploadProfileImage('/path/img.jpg'),
      ).thenAnswer((_) async => const Left(NetworkFailure('offline')));

      final result = await usecase.execute('/path/img.jpg');
      expect(result, const Left(NetworkFailure('offline')));
    });
  });
}
