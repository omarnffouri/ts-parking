import 'package:get/get.dart';

import '../../../core/di/injection_container.dart';
import '../../../core/services/secure_token_storage.dart';
import '../../../core/utils/error_handler.dart';
import '../../../core/widgets/confirm_dialog.dart';
import '../../../core/widgets/file_viewer_page.dart';
import '../../../domain/entities/invoice_entity.dart';
import '../../../domain/entities/subscription_entity.dart';
import '../../../domain/params/payment_args.dart';
import '../../../domain/usecases/delete_subscription_usecase.dart';
import '../../../domain/usecases/get_invoice_by_id_usecase.dart';
import '../../../routes/app_pages.dart';
import '../../../domain/entities/create_subscription_response_entity.dart';

class InvoiceDetailController extends GetxController {
  final GetInvoiceByIdUsecase getInvoiceByIdUsecase;
  final DeleteSubscriptionUsecase deleteSubscriptionUsecase;

  InvoiceDetailController({
    required this.getInvoiceByIdUsecase,
    required this.deleteSubscriptionUsecase,
  });

  final _invoice = Rxn<InvoiceEntity>();
  final _isLoading = false.obs;
  final _deletingIds = <int>{}.obs;

  InvoiceEntity? get invoice => _invoice.value;
  bool get isLoading => _isLoading.value;
  bool isDeleting(int subscriptionId) => _deletingIds.contains(subscriptionId);
  bool get canPay {
    final status = invoice?.status.toLowerCase();
    return status == 'pending' || status == 'unpaid';
  }

  bool get hasPdf {
    final url = invoice?.pdfUrl;
    return url != null && url.isNotEmpty;
  }

  late final int invoiceId;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    invoiceId = args is int ? args : int.parse(args.toString());
  }

  @override
  void onReady() {
    super.onReady();
    loadInvoice();
  }

  Future<void> loadInvoice() async {
    _isLoading.value = true;
    final result = await getInvoiceByIdUsecase.execute(invoiceId);
    result.fold(
      (failure) => ErrorHandler.showError('Error', failure.message),
      (data) => _invoice.value = data,
    );
    _isLoading.value = false;
  }

  Future<void> onViewPdf() async {
    final inv = invoice;
    final pdfUrl = inv?.pdfUrl;
    if (inv == null || pdfUrl == null || pdfUrl.isEmpty) return;

    try {
      final token = await sl<SecureTokenStorage>().getAccessToken();
      Get.to(
        () => FileViewerPage.fromUrl(
          url: pdfUrl,
          title: inv.invoiceNumber,
          headers: {if (token != null) 'Authorization': 'Bearer $token'},
        ),
      );
    } catch (e) {
      ErrorHandler.showError('Error', 'Failed to open invoice PDF');
    }
  }

  Future<void> confirmDeleteSubscription(
    SubscriptionEntity subscription,
  ) async {
    if (isDeleting(subscription.id)) return;

    final confirmed = await ConfirmDialog.show(
      title: 'Remove Subscription',
      message:
          'Slot ${subscription.slotCode ?? subscription.subscriptionRef} is no longer available. '
          'Remove it from this invoice so you can pay the correct amount?',
      confirmLabel: 'Remove',
      destructive: true,
    );
    if (!confirmed) return;

    _deletingIds.add(subscription.id);
    final result = await deleteSubscriptionUsecase.execute(subscription.id);
    _deletingIds.remove(subscription.id);

    await result.fold(
      (failure) async => ErrorHandler.showError('Error', failure.message),
      (_) async {
        ErrorHandler.showSuccess('Subscription removed from invoice');
        await loadInvoice();
        final current = _invoice.value;
        if (current == null || current.subscriptions.isEmpty) {
          Get.back();
        }
      },
    );
  }

  void onConfirmAndPay() {
    final inv = invoice;
    if (inv == null) return;
    Get.toNamed(
      Routes.PAYMENT,
      arguments: PaymentArgs(
        response: CreateSubscriptionResponseEntity(
          subscriptions: inv.subscriptions,
          invoice: inv,
        ),
        yardName: '',
      ),
    );
  }
}
