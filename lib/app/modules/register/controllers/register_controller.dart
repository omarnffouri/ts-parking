import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/utils/error_handler.dart';
import '../../../core/utils/validators.dart';
import '../../../domain/params/register_params.dart';
import '../../../domain/usecases/register_usecase.dart';
import '../views/widgets/license_source_sheet.dart';

class RegisterController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final RegisterUsecase registerUsecase;

  RegisterController({required this.registerUsecase});

  final ImagePicker _imagePicker = ImagePicker();
  final formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final passwordController = TextEditingController();
  final ssnController = TextEditingController();
  final mobileController = TextEditingController();
  final companyNameController = TextEditingController();
  final emailController = TextEditingController();

  late final AnimationController animationController;
  late final Animation<Offset> slideAnimation;
  late final Animation<double> fadeAnimation;

  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  final _licensePath = RxnString();
  String? get licensePath => _licensePath.value;
  String? get licenseFileName {
    final path = _licensePath.value;
    if (path == null) return null;
    return path.split('/').last.split('\\').last;
  }

  @override
  void onInit() {
    super.onInit();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.05), end: Offset.zero).animate(
          CurvedAnimation(
            parent: animationController,
            curve: Curves.easeOutCubic,
          ),
        );
    fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeOut),
    );
    animationController.forward();
  }

  String? validateFirstName(String? value) => Validators.validateName(value);
  String? validateLastName(String? value) => Validators.validateName(value);
  String? validatePassword(String? value) => Validators.validatePassword(value);
  String? validateMobile(String? value) =>
      Validators.validateMobileNumber(value);
  String? validateCompanyName(String? value) => Validators.validateName(value);
  String? validateEmail(String? value) => Validators.validateEmail(value);

  Future<void> pickLicense() async {
    final context = Get.context;
    if (context == null) return;

    showLicenseSourceSheet(
      context: context,
      onCameraTap: () => _pickLicenseImage(ImageSource.camera),
      onGalleryTap: () => _pickLicenseImage(ImageSource.gallery),
      onFileTap: _pickLicenseFile,
    );
  }

  void removeLicense() {
    _licensePath.value = null;
  }

  Future<void> _pickLicenseImage(ImageSource source) async {
    try {
      final file = await _imagePicker.pickImage(
        source: source,
        imageQuality: 85,
      );
      if (file != null) {
        _licensePath.value = file.path;
      }
    } catch (_) {
      ErrorHandler.showError(
        'Upload License',
        'Unable to pick the license image right now.',
      );
    }
  }

  Future<void> _pickLicenseFile() async {
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      );
      final path = result?.files.single.path;
      if (path == null) return;

      _licensePath.value = path;
    } catch (e) {
      ErrorHandler.showError(
        'Upload License',
        'Unable to pick the license file right now.',
      );
    }
  }

  Future<void> register() async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    _isLoading.value = true;

    try {
      final mobile = mobileController.text.replaceAll('-', '').trim();
      final ssn = ssnController.text.trim();

      final result = await registerUsecase.execute(
        RegisterParams(
          password: passwordController.text,
          mobileNumber: mobile,
          firstName: firstNameController.text.trim(),
          lastName: lastNameController.text.trim(),
          companyName: companyNameController.text.trim(),
          email: emailController.text.trim(),
          ssn: ssn.isEmpty ? null : ssn,
          companyLicensePath: _licensePath.value,
        ),
      );

      result.fold(
        (failure) =>
            ErrorHandler.showError('Registration Failed', failure.message),
        (_) {
          Get.back();
          ErrorHandler.showSuccess(
            'Your account has been created successfully',
          );
        },
      );
    } catch (e) {
      ErrorHandler.showError('Error', 'Something went wrong');
    } finally {
      _isLoading.value = false;
    }
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    passwordController.dispose();
    ssnController.dispose();
    mobileController.dispose();
    companyNameController.dispose();
    emailController.dispose();
    animationController.dispose();
    super.onClose();
  }
}
