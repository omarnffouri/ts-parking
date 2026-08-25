import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';

import '../../data/datasources/auth_local_datasource.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/datasources/payment_method_remote_datasource.dart';
import '../../data/datasources/vehicle_remote_datasource.dart';
import '../../data/datasources/subscription_remote_datasource.dart';
import '../../data/datasources/settings_remote_datasource.dart';
import '../../data/datasources/yard_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/payment_method_repository_impl.dart';
import '../../data/repositories/settings_repository_impl.dart';
import '../../data/repositories/subscription_repository_impl.dart';
import '../../data/repositories/vehicle_repository_impl.dart';
import '../../data/repositories/yard_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/payment_method_repository.dart';
import '../../domain/repositories/vehicle_repository.dart';
import '../../domain/repositories/subscription_repository.dart';
import '../../domain/repositories/settings_repository.dart';
import '../../domain/repositories/yard_repository.dart';
import '../../domain/usecases/add_card_usecase.dart';
import '../../domain/usecases/delete_card_usecase.dart';
import '../../domain/usecases/get_transactions_usecase.dart';
import '../../domain/usecases/get_user_cards_usecase.dart';
import '../../domain/usecases/set_default_card_usecase.dart';
import '../../domain/usecases/add_vehicle_usecase.dart';
import '../../domain/usecases/delete_vehicle_usecase.dart';
import '../../domain/usecases/get_vehicle_types_usecase.dart';
import '../../domain/usecases/get_vehicles_usecase.dart';
import '../../domain/usecases/get_pricing_plans_usecase.dart';
import '../../domain/usecases/get_settings_usecase.dart';
import '../../domain/usecases/get_yard_slots_usecase.dart';
import '../../domain/usecases/get_yard_zones_usecase.dart';
import '../../domain/usecases/get_yards_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/delete_account_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/send_otp_usecase.dart';
import '../../domain/usecases/upload_profile_image_usecase.dart';
import '../../domain/usecases/update_vehicle_usecase.dart';
import '../../domain/usecases/create_subscriptions_usecase.dart';
import '../../domain/usecases/delete_subscription_usecase.dart';
import '../../domain/usecases/get_invoice_by_id_usecase.dart';
import '../../domain/usecases/get_invoices_usecase.dart';
import '../../domain/usecases/get_subscriptions_usecase.dart';
import '../../domain/usecases/pay_invoice_usecase.dart';
import '../../domain/usecases/verify_otp_usecase.dart';
import '../../domain/usecases/get_notifications_usecase.dart';
import '../../domain/usecases/mark_notification_read_usecase.dart';
import '../../domain/usecases/mark_all_notifications_read_usecase.dart';
import '../../domain/usecases/get_unread_count_usecase.dart';
import '../../domain/usecases/get_vehicle_charges_usecase.dart';
import '../../domain/usecases/pay_overstay_charge_usecase.dart';
import '../../data/datasources/notification_remote_datasource.dart';
import '../../data/datasources/vehicle_charge_remote_datasource.dart';
import '../../data/repositories/notification_repository_impl.dart';
import '../../data/repositories/vehicle_charge_repository_impl.dart';
import '../../domain/repositories/notification_repository.dart';
import '../../domain/repositories/vehicle_charge_repository.dart';
import '../network/dio_client.dart';
import '../services/auth_service.dart';
import '../services/notification_service.dart';
import '../services/secure_token_storage.dart';
import '../services/stripe_card_token_service.dart';
import '../services/theme_service.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! External
  initExternal();

  //! Datasources
  initDataSources();

  //! Repositories
  initRepositories();

  //! Usecases
  initUsecases();

  //! Services (depends on usecases & repositories)
  initServices();

  // Load cached user into AuthService
  await sl<AuthService>().loadCachedUser();
}

void initExternal() {
  sl.registerSingleton<DioClient>(DioClient.instance);
  sl.registerSingleton<SecureTokenStorage>(SecureTokenStorage());

  // Wire SecureTokenStorage to DioClient
  sl<DioClient>().secureTokenStorage = sl<SecureTokenStorage>();

  sl.registerLazySingleton<GetStorage>(() => GetStorage());
  sl.registerLazySingleton<ThemeService>(() => ThemeService());
}

void initDataSources() {
  //! Auth
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(dioClient: sl()),
  );
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(storage: sl(), secureTokenStorage: sl()),
  );

  //! Vehicle
  sl.registerLazySingleton<IVehicleDataSource>(
    () => VehicleRemoteDataSourceImpl(dioClient: sl()),
  );

  //! Payment Method
  sl.registerLazySingleton<PaymentMethodRemoteDataSource>(
    () => PaymentMethodRemoteDataSourceImpl(dioClient: sl()),
  );

  //! Yard
  sl.registerLazySingleton<IYardDataSource>(
    () => YardDataSourceImpl(dioClient: sl()),
  );

  //! Subscription
  sl.registerLazySingleton<SubscriptionRemoteDataSource>(
    () => SubscriptionRemoteDataSourceImpl(dioClient: sl()),
  );

  //! Settings
  sl.registerLazySingleton<ISettingsRemoteDataSource>(
    () => SettingsRemoteDataSourceImpl(dioClient: sl()),
  );

  //! Notification
  sl.registerLazySingleton<NotificationRemoteDataSource>(
    () => NotificationRemoteDataSourceImpl(dioClient: sl()),
  );

  //! Vehicle Charge
  sl.registerLazySingleton<IVehicleChargeDataSource>(
    () => VehicleChargeRemoteDataSourceImpl(dioClient: sl()),
  );
}

void initRepositories() {
  //! Auth
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
  );

  //! Vehicle
  sl.registerLazySingleton<IVehicleRepository>(
    () => VehicleRepositoryImpl(dataSource: sl()),
  );

  //! Payment Method
  sl.registerLazySingleton<PaymentMethodRepository>(
    () => PaymentMethodRepositoryImpl(dataSource: sl()),
  );

  //! Yard
  sl.registerLazySingleton<IYardRepository>(
    () => YardRepositoryImpl(dataSource: sl()),
  );

  //! Subscription
  sl.registerLazySingleton<SubscriptionRepository>(
    () => SubscriptionRepositoryImpl(dataSource: sl()),
  );

  //! Settings
  sl.registerLazySingleton<ISettingsRepository>(
    () => SettingsRepositoryImpl(remoteDataSource: sl()),
  );

  //! Notification
  sl.registerLazySingleton<INotificationRepository>(
    () => NotificationRepositoryImpl(dataSource: sl()),
  );

  //! Vehicle Charge
  sl.registerLazySingleton<IVehicleChargeRepository>(
    () => VehicleChargeRepositoryImpl(dataSource: sl()),
  );
}

void initUsecases() {
  //! Auth
  sl.registerLazySingleton(() => LoginUsecase(sl()));
  sl.registerLazySingleton(() => RegisterUsecase(sl()));
  sl.registerLazySingleton(() => SendOtpUsecase(sl()));
  sl.registerLazySingleton(() => VerifyOtpUsecase(sl()));
  sl.registerLazySingleton(() => LogoutUsecase(sl()));
  sl.registerLazySingleton(() => DeleteAccountUsecase(sl()));

  //! Vehicle
  sl.registerLazySingleton(() => GetVehicleTypesUsecase(sl()));
  sl.registerLazySingleton(() => GetVehiclesUsecase(sl()));
  sl.registerLazySingleton(() => AddVehicleUsecase(sl()));
  sl.registerLazySingleton(() => UpdateVehicleUsecase(sl()));
  sl.registerLazySingleton(() => DeleteVehicleUsecase(sl()));

  //! Payment Method
  sl.registerLazySingleton(() => AddCardUsecase(sl()));
  sl.registerLazySingleton(() => DeleteCardUsecase(sl()));
  sl.registerLazySingleton(() => GetTransactionsUsecase(sl()));
  sl.registerLazySingleton(() => GetUserCardsUsecase(sl()));
  sl.registerLazySingleton(() => SetDefaultCardUsecase(sl()));

  //! Yard
  sl.registerLazySingleton(() => GetYardsUsecase(sl()));
  sl.registerLazySingleton(() => GetPricingPlansUsecase(sl()));
  sl.registerLazySingleton(() => GetYardSlotsUsecase(sl()));
  sl.registerLazySingleton(() => GetYardZonesUsecase(sl()));

  //! Settings
  sl.registerLazySingleton(() => GetSettingsUsecase(sl()));
  sl.registerLazySingleton(() => UploadProfileImageUsecase(sl()));

  //! Subscription
  sl.registerLazySingleton(() => GetSubscriptionsUsecase(sl()));
  sl.registerLazySingleton(() => CreateSubscriptionsUsecase(sl()));
  sl.registerLazySingleton(() => PayInvoiceUsecase(sl()));
  sl.registerLazySingleton(() => GetInvoicesUsecase(sl()));
  sl.registerLazySingleton(() => GetInvoiceByIdUsecase(sl()));
  sl.registerLazySingleton(() => DeleteSubscriptionUsecase(sl()));

  //! Notification
  sl.registerLazySingleton(() => GetNotificationsUsecase(sl()));
  sl.registerLazySingleton(() => MarkNotificationReadUsecase(sl()));
  sl.registerLazySingleton(() => MarkAllNotificationsReadUsecase(sl()));
  sl.registerLazySingleton(() => GetUnreadCountUsecase(sl()));

  //! Vehicle Charge
  sl.registerLazySingleton(() => GetVehicleChargesUsecase(sl()));
  sl.registerLazySingleton(() => PayOverstayChargeUsecase(sl()));
}

void initServices() {
  sl.registerLazySingleton<AuthService>(
    () => AuthService(logoutUsecase: sl(), authRepository: sl()),
  );
  sl.registerLazySingleton<StripeCardTokenService>(
    () => StripeCardTokenServiceImpl(),
  );
  sl.registerLazySingleton<NotificationService>(
    () => NotificationService(getUnreadCountUsecase: sl()),
  );
}
