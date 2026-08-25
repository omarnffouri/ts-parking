import 'package:flutter_test/flutter_test.dart';
import 'package:ts_parking/app/data/models/notification_model.dart';

void main() {
  test('fromJson parses all fields', () {
    final notification = NotificationModel.fromJson({
      'id': 5,
      'event_key': 'subscription_created',
      'title': 'New Subscription',
      'message': 'Your subscription has been created.',
      'payload': {'subscription_id': 89},
      'is_read': false,
      'created_at': '2026-04-03T18:36:35.000000Z',
    });

    expect(notification.id, 5);
    expect(notification.title, 'New Subscription');
    expect(notification.message, 'Your subscription has been created.');
    expect(notification.payload, isNotNull);
    expect(notification.isRead, isFalse);
  });

  test('fromJson handles null fields', () {
    final notification = NotificationModel.fromJson({
      'id': null,
      'event_key': null,
      'title': null,
      'message': null,
      'payload': null,
      'is_read': null,
      'created_at': null,
    });

    expect(notification.id, 0);
    expect(notification.title, '');
    expect(notification.message, '');
    expect(notification.payload, isNull);
    expect(notification.isRead, isFalse);
  });
}
