import 'package:equatable/equatable.dart';

import 'invoice_entity.dart';
import 'subscription_entity.dart';

class CreateSubscriptionResponseEntity extends Equatable {
  final List<SubscriptionEntity> subscriptions;
  final InvoiceEntity? invoice;

  const CreateSubscriptionResponseEntity({
    required this.subscriptions,
    this.invoice,
  });

  @override
  List<Object?> get props => [subscriptions, invoice];
}
