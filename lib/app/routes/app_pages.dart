import 'package:get/get.dart';

import '../modules/add_vehicle/bindings/add_vehicle_binding.dart';
import '../modules/add_vehicle/views/add_vehicle_view.dart';
import '../modules/booking_confirmation/bindings/booking_confirmation_binding.dart';
import '../modules/booking_confirmation/views/booking_confirmation_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/invoice_detail/bindings/invoice_detail_binding.dart';
import '../modules/invoice_detail/views/invoice_detail_view.dart';
import '../modules/invoices/bindings/invoices_binding.dart';
import '../modules/invoices/views/invoices_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/main_screen/bindings/main_screen_binding.dart';
import '../modules/main_screen/views/main_screen_view.dart';
import '../modules/map/bindings/map_binding.dart';
import '../modules/map/views/map_view.dart';
import '../modules/my_vehicles/bindings/my_vehicles_binding.dart';
import '../modules/my_vehicles/views/my_vehicles_view.dart';
import '../modules/notifications/bindings/notifications_binding.dart';
import '../modules/notifications/views/notifications_view.dart';
import '../modules/overstay_charges/bindings/overstay_charges_binding.dart';
import '../modules/overstay_charges/views/overstay_charges_view.dart';
import '../modules/on_boarding/bindings/on_boarding_binding.dart';
import '../modules/on_boarding/views/on_boarding_view.dart';
import '../modules/otp_verification/bindings/otp_verification_binding.dart';
import '../modules/otp_verification/views/otp_verification_view.dart';
import '../modules/payment/bindings/payment_binding.dart';
import '../modules/payment/views/payment_view.dart';
import '../modules/payment_method/bindings/payment_method_binding.dart';
import '../modules/payment_method/views/payment_method_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';
import '../modules/slot_selection/bindings/slot_selection_binding.dart';
import '../modules/slot_selection/views/slot_selection_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/subscriptions/bindings/subscriptions_binding.dart';
import '../modules/subscriptions/views/subscriptions_view.dart';

// ignore_for_file: constant_identifier_names

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.MAIN_SCREEN,
      page: () => const MainScreenView(),
      binding: MainScreenBinding(),
    ),
    GetPage(
      name: _Paths.MAP,
      page: () => const MapView(),
      binding: MapBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.ON_BOARDING,
      page: () => const OnBoardingView(),
      binding: OnBoardingBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.OTP_VERIFICATION,
      page: () => const OtpVerificationView(),
      binding: OtpVerificationBinding(),
    ),
    GetPage(
      name: _Paths.ADD_VEHICLE,
      page: () => const AddVehicleView(),
      binding: AddVehicleBinding(),
    ),
    GetPage(
      name: _Paths.MY_VEHICLES,
      page: () => const MyVehiclesView(),
      binding: MyVehiclesBinding(),
    ),
    GetPage(
      name: _Paths.SLOT_SELECTION,
      page: () => const SlotSelectionView(),
      binding: SlotSelectionBinding(),
    ),
    GetPage(
      name: _Paths.BOOKING_CONFIRMATION,
      page: () => const BookingConfirmationView(),
      binding: BookingConfirmationBinding(),
    ),
    GetPage(
      name: _Paths.PAYMENT_METHOD,
      page: () => const PaymentMethodView(),
      binding: PaymentMethodBinding(),
    ),
    GetPage(
      name: _Paths.PAYMENT,
      page: () => const PaymentView(),
      binding: PaymentBinding(),
    ),
    GetPage(
      name: _Paths.SUBSCRIPTIONS,
      page: () => const SubscriptionsView(),
      binding: SubscriptionsBinding(),
    ),
    GetPage(
      name: _Paths.INVOICES,
      page: () => const InvoicesView(),
      binding: InvoicesBinding(),
    ),
    GetPage(
      name: _Paths.INVOICE_DETAIL,
      page: () => const InvoiceDetailView(),
      binding: InvoiceDetailBinding(),
    ),
    GetPage(
      name: _Paths.NOTIFICATIONS,
      page: () => const NotificationsView(),
      binding: NotificationsBinding(),
    ),
    GetPage(
      name: _Paths.OVERSTAY_CHARGES,
      page: () => const OverstayChargesView(),
      binding: OverstayChargesBinding(),
    ),
  ];
}
