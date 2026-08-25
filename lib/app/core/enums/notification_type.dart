enum NotificationType {
  subscriptionRenewed,
  subscriptionActivated,
  subscriptionExpired,
  subscriptionCancelled,
  subscriptionCancelAtPeriodEnd,
  subscriptionAutoRenewToggled,
  invoicePaid,
  general,
}

extension NotificationTypeX on NotificationType {
  static final _apiMap = {
    for (final type in NotificationType.values) type.apiValue: type,
  };

  static NotificationType fromString(String value) {
    return _apiMap[value] ?? NotificationType.general;
  }

  static NotificationType fromData(Map<String, dynamic> data) {
    final value =
        data['event_key']?.toString() ?? data['type']?.toString() ?? '';
    return fromString(value);
  }

  String get apiValue {
    return switch (this) {
      NotificationType.subscriptionRenewed => 'subscription.renewed',
      NotificationType.subscriptionActivated => 'subscription.activated',
      NotificationType.subscriptionExpired => 'subscription.expired',
      NotificationType.subscriptionCancelled => 'subscription.cancelled',
      NotificationType.subscriptionCancelAtPeriodEnd =>
        'subscription.cancel_at_period_end',
      NotificationType.subscriptionAutoRenewToggled =>
        'subscription.auto_renew_toggled',
      NotificationType.invoicePaid => 'invoice.paid',
      NotificationType.general => 'general',
    };
  }

  String get displayName {
    return switch (this) {
      NotificationType.subscriptionRenewed => 'Subscription Renewed',
      NotificationType.subscriptionActivated => 'Subscription Activated',
      NotificationType.subscriptionExpired => 'Subscription Expired',
      NotificationType.subscriptionCancelled => 'Subscription Cancelled',
      NotificationType.subscriptionCancelAtPeriodEnd =>
        'Cancellation Scheduled',
      NotificationType.subscriptionAutoRenewToggled => 'Auto-Renew Updated',
      NotificationType.invoicePaid => 'Invoice Paid',
      NotificationType.general => 'General',
    };
  }

  bool get isSubscriptionType {
    return switch (this) {
      NotificationType.subscriptionRenewed ||
      NotificationType.subscriptionActivated ||
      NotificationType.subscriptionExpired ||
      NotificationType.subscriptionCancelled ||
      NotificationType.subscriptionCancelAtPeriodEnd ||
      NotificationType.subscriptionAutoRenewToggled => true,
      _ => false,
    };
  }
}
