import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/gen/assets.gen.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/utils/error_handler.dart';
import '../../../domain/usecases/delete_account_usecase.dart';
import '../../../domain/usecases/upload_profile_image_usecase.dart';
import '../../../routes/app_pages.dart';
import '../../../core/enums/profile_menu_item.dart';
import '../views/widgets/cover_photo_sheet.dart';
import '../views/widgets/delete_account_sheet.dart';
import '../views/widgets/profile_image_source_sheet.dart';

class ProfileController extends GetxController {
  final AuthService authService;
  final GetStorage storage;
  final UploadProfileImageUsecase uploadProfileImageUsecase;
  final DeleteAccountUsecase deleteAccountUsecase;
  final ImagePicker _imagePicker = ImagePicker();
  final RxnString _coverPhotoPath = RxnString();
  final RxnString _profileImagePath = RxnString();
  final RxnString _pendingProfileImagePath = RxnString();
  final RxBool _isUploadingProfileImage = false.obs;

  ProfileController({
    required this.authService,
    required this.storage,
    required this.uploadProfileImageUsecase,
    required this.deleteAccountUsecase,
  });

  @override
  void onInit() {
    super.onInit();
    _loadSavedCoverPhoto();
    _loadSavedProfileImage();
  }

  String get userName => authService.currentUser?.fullName ?? 'Guest';
  String? get userEmail =>
      authService.currentUser?.email?.trim().isNotEmpty == true
      ? authService.currentUser!.email!
      : null;
  String? get coverPhotoPath {
    final path = _coverPhotoPath.value;
    if (path == null || path.isEmpty) return null;
    return path;
  }

  bool get hasCustomCoverPhoto => coverPhotoPath != null;
  ImageProvider get coverPhotoProvider {
    final path = coverPhotoPath;
    if (path != null) {
      return FileImage(File(path));
    }
    return AssetImage(Assets.images.coverPhoto.path);
  }

  String? get activeProfileImagePath {
    final pendingPath = _pendingProfileImagePath.value;
    if (pendingPath != null && pendingPath.isNotEmpty) {
      return pendingPath;
    }

    final savedPath = _profileImagePath.value;
    if (savedPath != null && savedPath.isNotEmpty) {
      return savedPath;
    }

    return null;
  }

  String? get remoteProfileImageUrl {
    final url = authService.currentUser?.profileImageUrl?.trim();
    if (url == null || url.isEmpty) return null;
    return url;
  }

  bool get isUploadingProfileImage => _isUploadingProfileImage.value;

  final primaryMenuItems = const <ProfileMenuItem>[
    ProfileMenuItem.myVehicles,
    ProfileMenuItem.paymentMethods,
    ProfileMenuItem.subscriptions,
    ProfileMenuItem.invoices,
    ProfileMenuItem.overstayCharges,
    ProfileMenuItem.termsAndConditions,
  ];

  final accountItems = const <ProfileMenuItem>[
    ProfileMenuItem.deleteAccount,
    ProfileMenuItem.logout,
  ];

  void onMenuTap(ProfileMenuItem item) {
    if (item == ProfileMenuItem.logout) {
      if (!isLoggingOut) logout();
      return;
    }
    if (item == ProfileMenuItem.deleteAccount) {
      _confirmDeleteAccount();
      return;
    }
    if (item == ProfileMenuItem.termsAndConditions) {
      _launchTermsAndConditions();
      return;
    }

    final route = item.route;
    if (route != null) {
      Get.toNamed(route);
      return;
    }

    Get.snackbar('Navigate', 'Opening ${item.title}...');
  }

  void onEditProfileTap() {
    final context = Get.context;
    if (context == null) return;

    showProfileImageSourceSheet(
      context: context,
      onCameraTap: _handleProfileImageCameraTap,
      onGalleryTap: _handleProfileImageGalleryTap,
    );
  }

  void onCoverPhotoTap() {
    final context = Get.context;
    if (context == null) return;

    showCoverPhotoSheet(
      context: context,
      hasCustomCoverPhoto: hasCustomCoverPhoto,
      onChangeImage: _handleChangeCoverPhoto,
      onRemoveImage: _handleRemoveCoverPhoto,
    );
  }

  Future<void> pickCoverPhoto() async {
    try {
      final pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 90,
      );

      if (pickedFile == null) return;

      final previousPath = _coverPhotoPath.value;
      final savedPath = await _saveCoverPhoto(pickedFile);
      if (previousPath != null && previousPath.isNotEmpty) {
        await FileImage(File(previousPath)).evict();
      }
      _coverPhotoPath.value = savedPath;
      await storage.write(AppConstants.profileCoverPhotoKey, savedPath);
      _showQuickMessage('Cover photo updated');
    } catch (_) {
      Get.snackbar(
        'Cover Photo',
        'Unable to update the cover photo right now.',
      );
    }
  }

  Future<void> removeCoverPhoto() async {
    final previousPath = _coverPhotoPath.value;
    await _deleteCurrentCoverPhotoFile();
    _coverPhotoPath.value = null;
    await storage.remove(AppConstants.profileCoverPhotoKey);
    if (previousPath != null && previousPath.isNotEmpty) {
      await FileImage(File(previousPath)).evict();
    }
    _showQuickMessage('Cover photo removed');
  }

  final _isLoggingOut = false.obs;
  bool get isLoggingOut => _isLoggingOut.value;

  Future<void> logout() async {
    _isLoggingOut.value = true;
    await authService.logout();
    Get.offAllNamed(Routes.LOGIN);
  }

  final _isDeletingAccount = false.obs;
  bool get isDeletingAccount => _isDeletingAccount.value;

  void _confirmDeleteAccount() {
    showDeleteAccountSheet(this);
  }

  Future<void> deleteAccount() async {
    final userIdStr = authService.currentUser?.id;
    if (userIdStr == null || _isDeletingAccount.value) return;

    final userId = int.tryParse(userIdStr.toString());
    if (userId == null) return;

    _isDeletingAccount.value = true;
    final result = await deleteAccountUsecase.execute(userId);

    result.fold(
      (failure) {
        _isDeletingAccount.value = false;
        Get.back();
        ErrorHandler.showError('Error', failure.message);
      },
      (_) {
        authService.clearCurrentUser();
        Get.offAllNamed(Routes.LOGIN);
        ErrorHandler.showSuccess('Account deleted successfully');
      },
    );
  }

  void _loadSavedCoverPhoto() {
    final savedPath = storage.read<String>(AppConstants.profileCoverPhotoKey);

    if (savedPath == null || savedPath.trim().isEmpty) {
      _coverPhotoPath.value = null;
      return;
    }

    final file = File(savedPath);
    if (!file.existsSync()) {
      storage.remove(AppConstants.profileCoverPhotoKey);
      _coverPhotoPath.value = null;
      return;
    }

    _coverPhotoPath.value = savedPath;
  }

  void _loadSavedProfileImage() {
    final savedPath = storage.read<String>(AppConstants.profileImageKey);

    if (savedPath == null || savedPath.trim().isEmpty) {
      _profileImagePath.value = null;
      return;
    }

    final file = File(savedPath);
    if (!file.existsSync()) {
      storage.remove(AppConstants.profileImageKey);
      _profileImagePath.value = null;
      return;
    }

    _profileImagePath.value = savedPath;
  }

  Future<String> _saveCoverPhoto(XFile pickedFile) async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final extension = _resolveFileExtension(pickedFile.path);
    final targetPath =
        '${documentsDirectory.path}/${AppConstants.profileCoverPhotoKey}_${DateTime.now().millisecondsSinceEpoch}$extension';

    final targetFile = File(targetPath);
    if (targetFile.existsSync()) {
      await targetFile.delete();
    }

    await File(pickedFile.path).copy(targetPath);
    await _deleteCurrentCoverPhotoFile(exceptPath: targetPath);

    return targetPath;
  }

  Future<void> _deleteCurrentCoverPhotoFile({String? exceptPath}) async {
    final currentPath = _coverPhotoPath.value;
    if (currentPath == null ||
        currentPath.isEmpty ||
        currentPath == exceptPath) {
      return;
    }

    final file = File(currentPath);
    if (await file.exists()) {
      await file.delete();
    }
  }

  Future<String> _saveProfileImage(XFile pickedFile) async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final extension = _resolveFileExtension(pickedFile.path);
    final targetPath =
        '${documentsDirectory.path}/${AppConstants.profileImageKey}_${DateTime.now().millisecondsSinceEpoch}$extension';

    final targetFile = File(targetPath);
    if (targetFile.existsSync()) {
      await targetFile.delete();
    }

    await File(pickedFile.path).copy(targetPath);
    await _deleteCurrentProfileImageFile(exceptPath: targetPath);

    return targetPath;
  }

  Future<void> _deleteCurrentProfileImageFile({String? exceptPath}) async {
    final currentPath = _profileImagePath.value;
    if (currentPath == null ||
        currentPath.isEmpty ||
        currentPath == exceptPath) {
      return;
    }

    final file = File(currentPath);
    if (await file.exists()) {
      await file.delete();
    }
  }

  String _resolveFileExtension(String path) {
    final lastDotIndex = path.lastIndexOf('.');
    if (lastDotIndex == -1 || lastDotIndex == path.length - 1) {
      return '.jpg';
    }

    return path.substring(lastDotIndex);
  }

  Future<void> _handleChangeCoverPhoto(BuildContext sheetContext) async {
    Navigator.of(sheetContext).pop();
    await pickCoverPhoto();
  }

  Future<void> _handleRemoveCoverPhoto(BuildContext sheetContext) async {
    Navigator.of(sheetContext).pop();
    await removeCoverPhoto();
  }

  Future<void> _handleProfileImageCameraTap(BuildContext sheetContext) async {
    Navigator.of(sheetContext).pop();
    await _pickAndUploadProfileImage(ImageSource.camera);
  }

  Future<void> _handleProfileImageGalleryTap(BuildContext sheetContext) async {
    Navigator.of(sheetContext).pop();
    await _pickAndUploadProfileImage(ImageSource.gallery);
  }

  Future<void> _pickAndUploadProfileImage(ImageSource source) async {
    final pickedFile = await _imagePicker.pickImage(
      source: source,
      imageQuality: 90,
    );

    if (pickedFile == null) return;

    _pendingProfileImagePath.value = pickedFile.path;
    _isUploadingProfileImage.value = true;
    try {
      final result = await uploadProfileImageUsecase.execute(pickedFile.path);
      await result.fold(
        (failure) async {
          _pendingProfileImagePath.value = null;
          ErrorHandler.showError('Error', failure.message);
        },
        (_) async {
          final previousPath = _profileImagePath.value;
          final savedPath = await _saveProfileImage(pickedFile);
          if (previousPath != null && previousPath.isNotEmpty) {
            await FileImage(File(previousPath)).evict();
          }
          _profileImagePath.value = savedPath;
          _pendingProfileImagePath.value = null;
          await storage.write(AppConstants.profileImageKey, savedPath);
          _showQuickMessage('Profile image updated');
        },
      );
    } finally {
      _isUploadingProfileImage.value = false;
    }
  }

  Future<void> _launchTermsAndConditions() async {
    final url = Uri.parse('https://transport-system.com/privacy-policy/');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      ErrorHandler.showError('Error', 'Cannot launch url!');
    }
  }

  void _showQuickMessage(String message) {
    Get.closeAllSnackbars();
    Get.snackbar(
      'Success',
      message,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(12),
    );
  }
}
