import 'package:equatable/equatable.dart';

import '../../core/enums/notification_type.dart';

class NotificationEntity extends Equatable {
  final int id;
  final NotificationType type;
  final String title;
  final String message;
  final Map<String, dynamic>? payload;
  final bool isRead;
  final DateTime createdAt;

  const NotificationEntity({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    this.payload,
    this.isRead = false,
    required this.createdAt,
  });

  NotificationEntity copyWith({bool? isRead}) {
    return NotificationEntity(
      id: id,
      type: type,
      title: title,
      message: message,
      payload: payload,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    type,
    title,
    message,
    payload,
    isRead,
    createdAt,
  ];
}
