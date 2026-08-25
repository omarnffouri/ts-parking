import 'package:mockito/annotations.dart';
import 'package:ts_parking/app/core/services/stripe_card_token_service.dart';
import 'package:ts_parking/app/domain/repositories/auth_repository.dart';
import 'package:ts_parking/app/domain/repositories/payment_method_repository.dart';
import 'package:ts_parking/app/domain/repositories/vehicle_repository.dart';
import 'package:ts_parking/app/domain/repositories/yard_repository.dart';
import 'package:ts_parking/app/domain/repositories/subscription_repository.dart';
import 'package:ts_parking/app/domain/repositories/notification_repository.dart';
import 'package:ts_parking/app/domain/repositories/settings_repository.dart';
import 'package:ts_parking/app/domain/repositories/vehicle_charge_repository.dart';
import 'package:ts_parking/app/domain/usecases/add_card_usecase.dart';
import 'package:ts_parking/app/domain/usecases/delete_card_usecase.dart';
import 'package:ts_parking/app/domain/usecases/get_transactions_usecase.dart';
import 'package:ts_parking/app/domain/usecases/get_user_cards_usecase.dart';
import 'package:ts_parking/app/domain/usecases/set_default_card_usecase.dart';
import 'package:ts_parking/app/domain/usecases/logout_usecase.dart';

@GenerateMocks([
  AuthRepository,
  PaymentMethodRepository,
  IVehicleRepository,
  IYardRepository,
  SubscriptionRepository,
  INotificationRepository,
  ISettingsRepository,
  IVehicleChargeRepository,
  StripeCardTokenService,
  AddCardUsecase,
  DeleteCardUsecase,
  GetTransactionsUsecase,
  GetUserCardsUsecase,
  SetDefaultCardUsecase,
  LogoutUsecase,
])
void main() {}
