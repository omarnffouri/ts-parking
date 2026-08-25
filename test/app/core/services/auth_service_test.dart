import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';
import 'package:ts_parking/app/core/errors/failures.dart';
import 'package:ts_parking/app/core/services/auth_service.dart';
import 'package:ts_parking/app/domain/entities/user_entity.dart';

import '../../../helpers/mocks.mocks.dart';

UserEntity _makeUser({String id = '42', String? status = 'ACTIVE'}) {
  return UserEntity(id: id, status: status);
}

void main() {
  Get.testMode = true;

  late MockAuthRepository mockRepo;
  late MockLogoutUsecase mockLogout;
  late AuthService authService;

  setUp(() {
    mockRepo = MockAuthRepository();
    mockLogout = MockLogoutUsecase();
    authService = AuthService(
      logoutUsecase: mockLogout,
      authRepository: mockRepo,
    );
  });

  group('isLoggedIn', () {
    test('is false initially', () {
      expect(authService.isLoggedIn, isFalse);
    });

    test('becomes true after setCurrentUser', () {
      authService.setCurrentUser(_makeUser());
      expect(authService.isLoggedIn, isTrue);
    });

    test('becomes false after clearCurrentUser', () {
      authService.setCurrentUser(_makeUser());
      authService.clearCurrentUser();
      expect(authService.isLoggedIn, isFalse);
    });
  });

  group('isAccountPending', () {
    test('returns true when status is null', () {
      authService.setCurrentUser(_makeUser(status: null));
      expect(authService.isAccountPending, isTrue);
    });

    test('returns true when status is PENDING', () {
      authService.setCurrentUser(_makeUser(status: 'PENDING'));
      expect(authService.isAccountPending, isTrue);
    });

    test('returns true when status is pending (case insensitive)', () {
      authService.setCurrentUser(_makeUser(status: 'pending'));
      expect(authService.isAccountPending, isTrue);
    });

    test('returns false when status is ACTIVE', () {
      authService.setCurrentUser(_makeUser(status: 'ACTIVE'));
      expect(authService.isAccountPending, isFalse);
    });

    test('returns true when no user is set (currentUser is null)', () {
      expect(authService.isAccountPending, isTrue);
    });
  });

  group('loadCachedUser', () {
    test('sets user when cache returns a user', () async {
      final user = _makeUser(id: '99');
      when(mockRepo.getCachedUser()).thenAnswer((_) async => Right(user));

      await authService.loadCachedUser();

      expect(authService.isLoggedIn, isTrue);
      expect(authService.currentUser, equals(user));
      verify(mockRepo.getCachedUser()).called(1);
    });

    test('does nothing when cache returns null', () async {
      when(mockRepo.getCachedUser()).thenAnswer((_) async => const Right(null));

      await authService.loadCachedUser();

      expect(authService.isLoggedIn, isFalse);
      verify(mockRepo.getCachedUser()).called(1);
    });

    test('does nothing on failure', () async {
      when(
        mockRepo.getCachedUser(),
      ).thenAnswer((_) async => const Left(CacheFailure('cache miss')));

      await authService.loadCachedUser();

      expect(authService.isLoggedIn, isFalse);
      verify(mockRepo.getCachedUser()).called(1);
    });
  });

  group('logout', () {
    test('clears current user on successful logout', () async {
      authService.setCurrentUser(_makeUser());
      when(mockLogout.execute()).thenAnswer((_) async => const Right(null));

      try {
        await authService.logout();
      } catch (_) {
        // ErrorHandler.showInfo needs Get.context which is unavailable in tests
      }

      expect(authService.isLoggedIn, isFalse);
      verify(mockLogout.execute()).called(1);
    });

    test('clears current user even when logout fails', () async {
      authService.setCurrentUser(_makeUser());
      when(
        mockLogout.execute(),
      ).thenAnswer((_) async => const Left(ServerFailure('server down')));

      try {
        await authService.logout();
      } catch (_) {
        // ErrorHandler.showInfo needs Get.context
      }

      expect(authService.isLoggedIn, isFalse);
      verify(mockLogout.execute()).called(1);
    });
  });

  group('currentUserId', () {
    test('returns id as string when user is set', () {
      authService.setCurrentUser(_makeUser(id: '7'));
      expect(authService.currentUserId, equals('7'));
    });

    test('returns null when no user is set', () {
      expect(authService.currentUserId, isNull);
    });
  });
}
