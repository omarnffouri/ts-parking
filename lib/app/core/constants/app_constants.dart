class AppConstants {
  static const String appName = 'TS Parking';
  static const String appVersion = '1.0.0';

  // API Constants
  static const String baseUrl = 'https://parking.ts-portal.com/api';
  // static const String baseUrl = 'http://10.255.254.42/api';
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  static const String dashboard = '/dashboard';
  static const String appointments = '/appointments';

  // Auth API
  static const String driverLogin = '/drivers/login';
  static const String driverRegister = '/drivers/register';
  static const String sendOtp = '/otp/send';
  static const String verifyOtp = '/otp/verify';
  static const String driverLogout = '/drivers/logout';
  static const String driverDelete = '/drivers';
  static const String driverNotifications = '/drivers/notifications';
  static const String driverNotificationsUnreadCount =
      '/drivers/notifications/unread-count';
  static const String driverNotificationsReadAll =
      '/drivers/notifications/read-all';

  // Vehicle API
  static const String vehicles = '/vehicles';
  static const String vehicleTypes = '/vehicle-types';
  static const String yards = '/yards';
  static const String yardZones = '/yard-zones';
  static const String plans = '/plans';
  static const String addCard = '/payments/add-card';
  static const String userCards = '/payments/user-cards';
  static const String transactions = '/transactions';
  static const String setDefaultCard = '/payments/set-default-cards';
  static const String deleteCard = '/payments/delete-card';

  // Subscriptions
  static const String subscriptions = '/subscriptions';
  static const String payInvoice = '/subscriptions/pay';

  // Invoices
  static const String invoices = '/invoices';

  // Vehicle Charges (Overstay)
  static const String vehicleCharges = '/vehicles-charges';
  static const String overstayPay = '/overstay-pay';

  // Settings
  static const String settings = '/settings';
  static const String profileImage = '/profile/image';

  // Stripe
  static const String stripePublishableKey =
      'pk_test_51T6sXQKalIU4ytxJlHE8LpiUZ2wXUcBrmkNkqQtpSpAWC2WWa6ZTEZueZx6WfptQsTDjTIZds2MMt1bVy7vuFXbk00sNIpLuID';

  //TODO ADD KEY IN Environment
  //  String.fromEnvironment(
  //   'STRIPE_PUBLISHABLE_KEY',
  //   defaultValue:
  //       'pk_test_51T6sXQKalIU4ytxJlHE8LpiUZ2wXUcBrmkNkqQtpSpAWC2WWa6ZTEZueZx6WfptQsTDjTIZds2MMt1bVy7vuFXbk00sNIpLuID',
  // );

  // Storage Keyswhy so slow
  static const String tokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userKey = 'user_data';
  static const String themeKey = 'app_theme';

  static const String onboardingCompleteKey = 'onboarding_complete';
  static const String profileCoverPhotoKey = 'profile_cover_photo';
  static const String profileImageKey = 'profile_image';

  // Date Formats
  static const String dateFormat = 'yyyy-MM-dd';
  static const String timeFormat = 'HH:mm';
  static const String dateTimeFormat = 'yyyy-MM-dd HH:mm:ss';
  static const String displayDateFormat = 'dd MMM yyyy';
  static const String displayTimeFormat = 'hh:mm a';
}
