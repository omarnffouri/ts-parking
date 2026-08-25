import 'package:get/get.dart';
import '../services/notification_service.dart';
import '../../core/utils/error_handler.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/logout_usecase.dart';

class AuthService extends GetxController {
  final LogoutUsecase logoutUsecase;
  final AuthRepository authRepository;

  AuthService({required this.logoutUsecase, required this.authRepository});

  final _currentUser = Rxn<UserEntity>();
  final _isLoading = false.obs;

  UserEntity? get currentUser => _currentUser.value;
  String? get currentUserId => _currentUser.value?.id.toString();
  bool get isLoading => _isLoading.value;
  bool get isLoggedIn => _currentUser.value != null;

  bool get isAccountPending {
    final status = _currentUser.value?.status?.toUpperCase();
    if (status == null) return true;
    return status == 'PENDING';
  }

  /// Load cached user from local storage on app startup
  Future<void> loadCachedUser() async {
    final result = await authRepository.getCachedUser();
    result.fold((_) {}, (user) {
      if (user != null) {
        _currentUser.value = user;
      }
    });
  }

  void setCurrentUser(UserEntity user) {
    _currentUser.value = user;
  }

  void clearCurrentUser() {
    _currentUser.value = null;
  }

  Future<void> logout() async {
    _isLoading.value = true;

    try {
      await Get.find<NotificationService>().clearForUser();
    } catch (_) {}

    try {
      final result = await logoutUsecase.execute();
      result.fold(
        (_) => ErrorHandler.showInfo('Logged Out', 'You have been logged out'),
        (_) => ErrorHandler.showInfo(
          'Goodbye',
          'You have been logged out successfully',
        ),
      );
    } catch (e) {
      ErrorHandler.showInfo('Logged Out', 'You have been logged out');
    } finally {
      clearCurrentUser();
      _isLoading.value = false;
    }
  }

  Stream<UserEntity?> get userStream => _currentUser.stream;
}
