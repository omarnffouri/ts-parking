import 'package:get/get.dart';

import '../../../core/di/injection_container.dart';
import '../controllers/invoice_detail_controller.dart';

class InvoiceDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InvoiceDetailController>(
      () => InvoiceDetailController(
        getInvoiceByIdUsecase: sl(),
        deleteSubscriptionUsecase: sl(),
      ),
    );
  }
}
