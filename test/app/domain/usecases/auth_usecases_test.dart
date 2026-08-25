import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:ts_parking/app/core/errors/failures.dart';
import 'package:ts_parking/app/domain/entities/login_response.dart';
import 'package:ts_parking/app/domain/params/driver_params.dart';
import 'package:ts_parking/app/domain/params/otp_params.dart';
import 'package:ts_parking/app/domain/params/register_params.dart';

import 'package:ts_parking/app/domain/usecases/delete_account_usecase.dart';
import 'package:ts_parking/app/domain/usecases/login_usecase.dart';
import 'package:ts_parking/app/domain/usecases/logout_usecase.dart';
import 'package:ts_parking/app/domain/usecases/register_usecase.dart';
import 'package:ts_parking/app/domain/usecases/send_otp_usecase.dart';
import 'package:ts_parking/app/domain/usecases/verify_otp_usecase.dart';

import '../../../helpers/mocks.mocks.dart';

void main() {
  // ---------------------------------------------------------------------------
  // LoginUsecase
  // ---------------------------------------------------------------------------
  group('LoginUsecase', () {
    late MockAuthRepository mockRepo;
    late LoginUsecase usecase;

    setUp(() {
      mockRepo = MockAuthRepository();
      usecase = LoginUsecase(mockRepo);
    });

    test('delegates to repository.login and returns result', () async {
      const params = LoginParams(
        password: 'password123',
        mobileNumber: '0501234567',
        fcmToken: 'test-fcm-token',
      );
      const expected = LoginResponse(verified: true, accessToken: 'tok_123');
      when(
        mockRepo.login(params),
      ).thenAnswer((_) async => const Right(expected));

      final result = await usecase.execute(params);

      expect(result, const Right(expected));
      verify(mockRepo.login(params)).called(1);
      verifyNoMoreInteractions(mockRepo);
    });

    test('returns failure from repository', () async {
      const params = LoginParams(
        password: 'password123',
        mobileNumber: '0501234567',
        fcmToken: 'test-fcm-token',
      );
      const failure = ServerFailure('login failed');
      when(mockRepo.login(params)).thenAnswer((_) async => const Left(failure));

      final result = await usecase.execute(params);

      expect(result, const Left(failure));
      verify(mockRepo.login(params)).called(1);
    });
  });

  // ---------------------------------------------------------------------------
  // SendOtpUsecase
  // ---------------------------------------------------------------------------
  group('SendOtpUsecase', () {
    late MockAuthRepository mockRepo;
    late SendOtpUsecase usecase;

    setUp(() {
      mockRepo = MockAuthRepository();
      usecase = SendOtpUsecase(mockRepo);
    });

    test('delegates to repository.sendOtp and returns result', () async {
      const params = SendOtpParams(
        password: 'password123',
        mobileNumber: '0501234567',
      );
      when(
        mockRepo.sendOtp(params),
      ).thenAnswer((_) async => const Right('test-request-id'));

      final result = await usecase.execute(params);

      expect(result, const Right('test-request-id'));
      verify(mockRepo.sendOtp(params)).called(1);
      verifyNoMoreInteractions(mockRepo);
    });

    test('returns failure from repository', () async {
      const params = SendOtpParams(
        password: 'password123',
        mobileNumber: '0501234567',
      );
      const failure = ServerFailure('otp send failed');
      when(
        mockRepo.sendOtp(params),
      ).thenAnswer((_) async => const Left(failure));

      final result = await usecase.execute(params);

      expect(result, const Left(failure));
      verify(mockRepo.sendOtp(params)).called(1);
    });
  });

  // ---------------------------------------------------------------------------
  // VerifyOtpUsecase
  // ---------------------------------------------------------------------------
  group('VerifyOtpUsecase', () {
    late MockAuthRepository mockRepo;
    late VerifyOtpUsecase usecase;

    setUp(() {
      mockRepo = MockAuthRepository();
      usecase = VerifyOtpUsecase(mockRepo);
    });

    test('delegates to repository.verifyOtp and returns result', () async {
      const params = VerifyOtpParams(
        password: 'password123',
        mobileNumber: '0501234567',
        otpCode: '1234',
        requestId: 'test-request-id',
      );
      const expected = LoginResponse(verified: true, accessToken: 'tok_abc');
      when(
        mockRepo.verifyOtp(params),
      ).thenAnswer((_) async => const Right(expected));

      final result = await usecase.execute(params);

      expect(result, const Right(expected));
      verify(mockRepo.verifyOtp(params)).called(1);
      verifyNoMoreInteractions(mockRepo);
    });

    test('returns failure from repository', () async {
      const params = VerifyOtpParams(
        password: 'password123',
        mobileNumber: '0501234567',
        otpCode: '0000',
        requestId: 'test-request-id',
      );
      const failure = ServerFailure('invalid otp');
      when(
        mockRepo.verifyOtp(params),
      ).thenAnswer((_) async => const Left(failure));

      final result = await usecase.execute(params);

      expect(result, const Left(failure));
      verify(mockRepo.verifyOtp(params)).called(1);
    });
  });

  // ---------------------------------------------------------------------------
  // RegisterUsecase
  // ---------------------------------------------------------------------------
  group('RegisterUsecase', () {
    late MockAuthRepository mockRepo;
    late RegisterUsecase usecase;

    setUp(() {
      mockRepo = MockAuthRepository();
      usecase = RegisterUsecase(mockRepo);
    });

    test('delegates to repository.register and returns result', () async {
      const params = RegisterParams(
        password: 'password123',
        mobileNumber: '0501234567',
        firstName: 'John',
        lastName: 'Doe',
        companyName: 'Test Company',
        email: 'john@test.com',
      );
      when(
        mockRepo.register(params),
      ).thenAnswer((_) async => const Right(null));

      final result = await usecase.execute(params);

      result.fold(
        (failure) => fail('expected Right but got Left($failure)'),
        (_) => expect(true, isTrue),
      );
      verify(mockRepo.register(params)).called(1);
      verifyNoMoreInteractions(mockRepo);
    });

    test('returns failure from repository', () async {
      const params = RegisterParams(
        password: 'password123',
        mobileNumber: '0501234567',
        firstName: 'John',
        lastName: 'Doe',
        companyName: 'Test Company',
        email: 'john@test.com',
      );
      const failure = ServerFailure('register failed');
      when(
        mockRepo.register(params),
      ).thenAnswer((_) async => const Left(failure));

      final result = await usecase.execute(params);

      expect(result, const Left(failure));
      verify(mockRepo.register(params)).called(1);
    });
  });

  // ---------------------------------------------------------------------------
  // LogoutUsecase
  // ---------------------------------------------------------------------------
  group('LogoutUsecase', () {
    late MockAuthRepository mockRepo;
    late LogoutUsecase usecase;

    setUp(() {
      mockRepo = MockAuthRepository();
      usecase = LogoutUsecase(mockRepo);
    });

    test('delegates to repository.logout and returns result', () async {
      when(mockRepo.logout()).thenAnswer((_) async => const Right(null));

      final result = await usecase.execute();

      result.fold(
        (failure) => fail('expected Right but got Left($failure)'),
        (_) => expect(true, isTrue),
      );
      verify(mockRepo.logout()).called(1);
      verifyNoMoreInteractions(mockRepo);
    });

    test('returns failure from repository', () async {
      const failure = ServerFailure('logout failed');
      when(mockRepo.logout()).thenAnswer((_) async => const Left(failure));

      final result = await usecase.execute();

      expect(result, const Left(failure));
      verify(mockRepo.logout()).called(1);
    });
  });

  // ---------------------------------------------------------------------------
  // DeleteAccountUsecase
  // ---------------------------------------------------------------------------
  group('DeleteAccountUsecase', () {
    late MockAuthRepository mockRepo;
    late DeleteAccountUsecase usecase;

    setUp(() {
      mockRepo = MockAuthRepository();
      usecase = DeleteAccountUsecase(mockRepo);
    });

    test('delegates to repository.deleteAccount and returns result', () async {
      when(
        mockRepo.deleteAccount(7),
      ).thenAnswer((_) async => const Right(null));

      final result = await usecase.execute(7);

      expect(result.isRight(), isTrue);
      verify(mockRepo.deleteAccount(7)).called(1);
    });

    test('returns failure from repository', () async {
      const failure = ServerFailure('delete failed');
      when(
        mockRepo.deleteAccount(7),
      ).thenAnswer((_) async => const Left(failure));

      final result = await usecase.execute(7);

      expect(result, const Left(failure));
    });
  });
}
