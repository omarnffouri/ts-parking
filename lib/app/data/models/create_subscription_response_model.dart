import '../../domain/entities/create_subscription_response_entity.dart';
import 'invoice_model.dart';
import 'subscription_model.dart';

class CreateSubscriptionResponseModel extends CreateSubscriptionResponseEntity {
  const CreateSubscriptionResponseModel({
    required super.subscriptions,
    super.invoice,
  });

  factory CreateSubscriptionResponseModel.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];

    // cat_driver format: data is a flat list of subscriptions, no invoice
    if (rawData is List) {
      return CreateSubscriptionResponseModel(
        subscriptions: rawData
            .map((s) => SubscriptionModel.fromJson(s as Map<String, dynamic>))
            .toList(),
      );
    }

    // Regular user format: data is {subscriptions: [...], invoice: {...}}
    final data = rawData as Map<String, dynamic>;
    final subscriptionsJson = data['subscriptions'] as List<dynamic>;
    final invoiceJson = data['invoice'] as Map<String, dynamic>?;

    return CreateSubscriptionResponseModel(
      subscriptions: subscriptionsJson
          .map((s) => SubscriptionModel.fromJson(s as Map<String, dynamic>))
          .toList(),
      invoice: invoiceJson != null ? InvoiceModel.fromJson(invoiceJson) : null,
    );
  }
}
