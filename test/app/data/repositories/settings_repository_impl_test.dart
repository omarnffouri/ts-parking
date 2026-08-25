import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ts_parking/app/core/errors/exceptions.dart';
import 'package:ts_parking/app/core/errors/failures.dart';
import 'package:ts_parking/app/data/datasources/settings_remote_datasource.dart';
import 'package:ts_parking/app/data/models/settings_model.dart';
import 'package:ts_parking/app/data/repositories/settings_repository_impl.dart';

class FakeSettingsDataSource implements ISettingsRemoteDataSource {
  SettingsModel? getSettingsResult;
  Exception? getSettingsError;
  Exception? uploadImageError;
  bool uploadImageCalled = false;

  @override
  Future<SettingsModel> getSettings() async {
    if (getSettingsError != null) throw getSettingsError!;
    return getSettingsResult!;
  }

  @override
  Future<void> uploadProfileImage(String imagePath) async {
    uploadImageCalled = true;
    if (uploadImageError != null) throw uploadImageError!;
  }
}

void main() {
  late FakeSettingsDataSource fakeDataSource;
  late SettingsRepositoryImpl repository;

  setUp(() {
    fakeDataSource = FakeSettingsDataSource();
    repository = SettingsRepositoryImpl(remoteDataSource: fakeDataSource);
  });

  test('getSettings returns Right on success', () async {
    fakeDataSource.getSettingsResult = const SettingsModel(
      currencyCode: 'USD',
      discountRate: 10.0,
      taxRate: 5.0,
      isTaxInclusive: false,
      otpEnabled: true,
    );

    final result = await repository.getSettings();
    result.fold((_) => fail('expected Right'), (settings) {
      expect(settings.currencyCode, 'USD');
      expect(settings.discountRate, 10.0);
    });
  });

  test('getSettings returns Left on ServerException', () async {
    fakeDataSource.getSettingsError = ServerException('fail');

    final result = await repository.getSettings();
    expect(result, const Left(ServerFailure('fail')));
  });

  test('uploadProfileImage returns Right on success', () async {
    final result = await repository.uploadProfileImage('/path/to/image.jpg');
    expect(result.isRight(), isTrue);
    expect(fakeDataSource.uploadImageCalled, isTrue);
  });

  test('uploadProfileImage returns Left on NetworkException', () async {
    fakeDataSource.uploadImageError = NetworkException('offline');

    final result = await repository.uploadProfileImage('/path/to/image.jpg');
    expect(result, const Left(NetworkFailure('offline')));
  });
}
