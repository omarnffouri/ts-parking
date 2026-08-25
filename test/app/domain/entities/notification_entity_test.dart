import 'package:flutter_test/flutter_test.dart';
import 'package:ts_parking/app/domain/entities/notification_entity.dart';
import 'package:ts_parking/app/core/enums/notification_type.dart';

void main() {
  test('equatable compares by value', () {
    final now = DateTime.now();
    final a = NotificationEntity(
      id: 1,
      type: NotificationType.subscriptionActivated,
      title: 'Test',
      message: 'Hello',
      createdAt: now,
    );
    final b = NotificationEntity(
      id: 1,
      type: NotificationType.subscriptionActivated,
      title: 'Test',
      message: 'Hello',
      createdAt: now,
    );

    expect(a, equals(b));
  });

  test('defaults isRead to false', () {
    final entity = NotificationEntity(
      id: 1,
      type: NotificationType.general,
      title: 'Test',
      message: 'Msg',
      createdAt: DateTime.now(),
    );

    expect(entity.isRead, isFalse);
  });
}
