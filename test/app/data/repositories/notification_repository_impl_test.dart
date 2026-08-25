import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ts_parking/app/core/errors/exceptions.dart';
import 'package:ts_parking/app/core/errors/failures.dart';
import 'package:ts_parking/app/data/datasources/notification_remote_datasource.dart';
import 'package:ts_parking/app/data/models/notification_model.dart';
import 'package:ts_parking/app/data/models/paginated_response.dart';
import 'package:ts_parking/app/data/repositories/notification_repository_impl.dart';
import 'package:ts_parking/app/domain/params/notification_params.dart';

class FakeNotificationDataSource implements NotificationRemoteDataSource {
  PaginatedResponse<NotificationModel>? getNotificationsResult;
  Exception? getNotificationsError;
  Exception? markAsReadError;
  Exception? markAllAsReadError;
  int? unreadCountResult;
  Exception? unreadCountError;

  @override
  Future<PaginatedResponse<NotificationModel>> getNotifications(
    NotificationFilterParams params,
  ) async {
    if (getNotificationsError != null) throw getNotificationsError!;
    return getNotificationsResult!;
  }

  @override
  Future<void> markAsRead(int id) async {
    if (markAsReadError != null) throw markAsReadError!;
  }

  @override
  Future<void> markAllAsRead() async {
    if (markAllAsReadError != null) throw markAllAsReadError!;
  }

  @override
  Future<int> getUnreadCount() async {
    if (unreadCountError != null) throw unreadCountError!;
    return unreadCountResult ?? 0;
  }
}

void main() {
  late FakeNotificationDataSource fakeDataSource;
  late NotificationRepositoryImpl repository;

  setUp(() {
    fakeDataSource = FakeNotificationDataSource();
    repository = NotificationRepositoryImpl(dataSource: fakeDataSource);
  });

  test('getNotifications returns Right on success', () async {
    fakeDataSource.getNotificationsResult = const PaginatedResponse(
      data: [],
      meta: PaginationMeta.empty,
    );

    final result = await repository.getNotifications(
      const NotificationFilterParams(),
    );
    expect(result.isRight(), isTrue);
  });

  test('getNotifications returns Left on ServerException', () async {
    fakeDataSource.getNotificationsError = ServerException('fail');

    final result = await repository.getNotifications(
      const NotificationFilterParams(),
    );
    expect(result, const Left(ServerFailure('fail')));
  });

  test('markAsRead returns Right on success', () async {
    final result = await repository.markAsRead(1);
    expect(result.isRight(), isTrue);
  });

  test('markAllAsRead returns Right on success', () async {
    final result = await repository.markAllAsRead();
    expect(result.isRight(), isTrue);
  });

  test('getUnreadCount returns Right with count', () async {
    fakeDataSource.unreadCountResult = 5;

    final result = await repository.getUnreadCount();
    result.fold((_) => fail('expected Right'), (count) => expect(count, 5));
  });

  test('getUnreadCount returns Left on NetworkException', () async {
    fakeDataSource.unreadCountError = NetworkException('offline');

    final result = await repository.getUnreadCount();
    expect(result, const Left(NetworkFailure('offline')));
  });
}
