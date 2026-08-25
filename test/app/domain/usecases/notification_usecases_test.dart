import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:ts_parking/app/core/errors/failures.dart';
import 'package:ts_parking/app/data/models/paginated_response.dart';
import 'package:ts_parking/app/domain/usecases/get_notifications_usecase.dart';
import 'package:ts_parking/app/domain/usecases/mark_notification_read_usecase.dart';
import 'package:ts_parking/app/domain/usecases/mark_all_notifications_read_usecase.dart';
import 'package:ts_parking/app/domain/usecases/get_unread_count_usecase.dart';

import '../../../helpers/mocks.mocks.dart';

void main() {
  group('GetNotificationsUsecase', () {
    late MockINotificationRepository mockRepo;
    late GetNotificationsUsecase usecase;

    setUp(() {
      mockRepo = MockINotificationRepository();
      usecase = GetNotificationsUsecase(mockRepo);
    });

    test('delegates to repository and returns result', () async {
      when(mockRepo.getNotifications(any)).thenAnswer(
        (_) async => const Right(
          PaginatedResponse(data: [], meta: PaginationMeta.empty),
        ),
      );

      final result = await usecase.execute();
      expect(result.isRight(), isTrue);
      verify(mockRepo.getNotifications(any)).called(1);
    });

    test('returns failure from repository', () async {
      when(
        mockRepo.getNotifications(any),
      ).thenAnswer((_) async => const Left(ServerFailure('fail')));

      final result = await usecase.execute();
      expect(result, const Left(ServerFailure('fail')));
    });
  });

  group('MarkNotificationReadUsecase', () {
    late MockINotificationRepository mockRepo;
    late MarkNotificationReadUsecase usecase;

    setUp(() {
      mockRepo = MockINotificationRepository();
      usecase = MarkNotificationReadUsecase(mockRepo);
    });

    test('delegates to repository', () async {
      when(mockRepo.markAsRead(1)).thenAnswer((_) async => const Right(null));

      final result = await usecase.execute(1);
      expect(result.isRight(), isTrue);
      verify(mockRepo.markAsRead(1)).called(1);
    });
  });

  group('MarkAllNotificationsReadUsecase', () {
    late MockINotificationRepository mockRepo;
    late MarkAllNotificationsReadUsecase usecase;

    setUp(() {
      mockRepo = MockINotificationRepository();
      usecase = MarkAllNotificationsReadUsecase(mockRepo);
    });

    test('delegates to repository', () async {
      when(mockRepo.markAllAsRead()).thenAnswer((_) async => const Right(null));

      final result = await usecase.execute();
      expect(result.isRight(), isTrue);
      verify(mockRepo.markAllAsRead()).called(1);
    });
  });

  group('GetUnreadCountUsecase', () {
    late MockINotificationRepository mockRepo;
    late GetUnreadCountUsecase usecase;

    setUp(() {
      mockRepo = MockINotificationRepository();
      usecase = GetUnreadCountUsecase(mockRepo);
    });

    test('returns count from repository', () async {
      when(mockRepo.getUnreadCount()).thenAnswer((_) async => const Right(5));

      final result = await usecase.execute();
      result.fold((_) => fail('expected Right'), (count) => expect(count, 5));
    });

    test('returns failure from repository', () async {
      when(
        mockRepo.getUnreadCount(),
      ).thenAnswer((_) async => const Left(NetworkFailure('offline')));

      final result = await usecase.execute();
      expect(result, const Left(NetworkFailure('offline')));
    });
  });
}
