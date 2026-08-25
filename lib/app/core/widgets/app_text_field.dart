import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';

/// AppTextField - Reusable text input component with multiple variants
/// Follows DriveFlow design system specifications
enum AppTextFieldType { text, email, password, search }

class AppTextField extends StatefulWidget {
  final String? label;
  final String? hint;
  final String? helperText;
  final String? errorText;
  final String? initialValue;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final AppTextFieldType type;
  final bool enabled;
  final bool readOnly;
  final int? maxLines;
  final int? maxLength;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final void Function(String)? onSubmitted;
  final VoidCallback? onClear;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization textCapitalization;
  final EdgeInsetsGeometry? contentPadding;
  final bool showLabel;
  final bool showBorder;
  final Color? borderColor;
  final Color? normalBorderColor;
  final Color? focusedBorderColor;
  final Color? errorBorderColor;
  final Color? focusedErrorBorderColor;
  final Color? disabledBorderColor;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final Widget? labelAction;

  const AppTextField({
    super.key,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.initialValue,
    this.controller,
    this.keyboardType,
    this.type = AppTextFieldType.text,
    this.enabled = true,
    this.readOnly = false,
    this.maxLines = 1,
    this.maxLength,
    this.validator,
    this.onChanged,
    this.onTap,
    this.onSubmitted,
    this.onClear,
    this.prefixIcon,
    this.suffixIcon,
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.none,
    this.contentPadding,
    this.showLabel = true,
    this.showBorder = true,
    this.borderColor,
    this.normalBorderColor,
    this.focusedBorderColor,
    this.errorBorderColor,
    this.focusedErrorBorderColor,
    this.disabledBorderColor,
    this.focusNode,
    this.textInputAction,
    this.labelAction,
  });

  /// Email text field with validation
  const AppTextField.email({
    super.key,
    this.label,
    this.hint,
    this.errorText,
    this.controller,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.showLabel = true,
    this.showBorder = true,
    this.borderColor,
    this.normalBorderColor,
    this.focusedBorderColor,
    this.errorBorderColor,
    this.focusedErrorBorderColor,
    this.disabledBorderColor,
    this.focusNode,
    this.textInputAction,
  }) : type = AppTextFieldType.email,
       keyboardType = TextInputType.emailAddress,
       prefixIcon = const Icon(Icons.email_outlined),
       textCapitalization = TextCapitalization.none,
       helperText = null,
       initialValue = null,
       enabled = true,
       readOnly = false,
       maxLines = 1,
       maxLength = null,
       onTap = null,
       onClear = null,
       suffixIcon = null,
       inputFormatters = null,
       contentPadding = null,
       labelAction = null;

  /// Password text field with visibility toggle
  const AppTextField.password({
    super.key,
    this.label,
    this.hint,
    this.errorText,
    this.controller,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.showLabel = true,
    this.showBorder = true,
    this.borderColor,
    this.normalBorderColor,
    this.focusedBorderColor,
    this.errorBorderColor,
    this.focusedErrorBorderColor,
    this.disabledBorderColor,
    this.focusNode,
    this.textInputAction,
  }) : type = AppTextFieldType.password,
       keyboardType = null,
       prefixIcon = const Icon(Icons.lock_outline_rounded),
       textCapitalization = TextCapitalization.none,
       helperText = null,
       initialValue = null,
       enabled = true,
       readOnly = false,
       maxLines = 1,
       maxLength = null,
       onTap = null,
       onClear = null,
       suffixIcon = null,
       inputFormatters = null,
       contentPadding = null,
       labelAction = null;

  /// Search text field with clear button
  const AppTextField.search({
    super.key,
    this.hint,
    this.controller,
    this.onChanged,
    this.onClear,
    this.showBorder = true,
    this.borderColor,
    this.normalBorderColor,
    this.focusedBorderColor,
    this.errorBorderColor,
    this.focusedErrorBorderColor,
    this.disabledBorderColor,
    this.focusNode,
  }) : type = AppTextFieldType.search,
       label = null,
       errorText = null,
       helperText = null,
       initialValue = null,
       keyboardType = null,
       enabled = true,
       readOnly = false,
       maxLines = 1,
       maxLength = null,
       validator = null,
       onTap = null,
       onSubmitted = null,
       prefixIcon = const Icon(Icons.search_rounded),
       suffixIcon = null,
       inputFormatters = null,
       textCapitalization = TextCapitalization.none,
       contentPadding = null,
       showLabel = false,
       textInputAction = TextInputAction.search,
       labelAction = null;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late final TextEditingController _internalController;
  late final bool _isInternalController;
  late final FocusNode _internalFocusNode;
  late final bool _isInternalFocusNode;
  bool _obscureText = false;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.type == AppTextFieldType.password;

    // Controller setup
    _isInternalController = widget.controller == null;
    if (_isInternalController) {
      _internalController = TextEditingController(text: widget.initialValue);
    } else {
      _internalController = widget.controller!;
    }

    // FocusNode setup
    _isInternalFocusNode = widget.focusNode == null;
    if (_isInternalFocusNode) {
      _internalFocusNode = FocusNode();
    } else {
      _internalFocusNode = widget.focusNode!;
    }

    _internalFocusNode.addListener(() {
      setState(() {
        _isFocused = _internalFocusNode.hasFocus;
      });
    });

    // Listen to controller changes for search field
    if (widget.type == AppTextFieldType.search) {
      _internalController.addListener(() {
        setState(() {}); // Rebuild to show/hide clear button
      });
    }
  }

  @override
  void dispose() {
    if (_isInternalController) {
      _internalController.dispose();
    }
    if (_isInternalFocusNode) {
      _internalFocusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null && widget.showLabel) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.label!,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.textTheme.bodySmall?.color?.withValues(
                    alpha: 0.7,
                  ),
                ),
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: widget.labelAction ?? const SizedBox.shrink(),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.labelInputSpacing),
        ],
        Opacity(
          opacity: widget.enabled ? 1.0 : 0.4,
          child: IgnorePointer(
            ignoring: !widget.enabled,
            child: TextFormField(
              controller: _internalController,
              focusNode: _internalFocusNode,
              keyboardType: widget.keyboardType,
              obscureText: _obscureText,
              enabled: true,
              readOnly: widget.readOnly,
              maxLines: widget.maxLines,
              maxLength: widget.maxLength,
              validator: widget.validator,
              onChanged: widget.onChanged,
              onTap: widget.onTap,
              onFieldSubmitted: widget.onSubmitted,
              inputFormatters: widget.inputFormatters,
              textCapitalization: widget.textCapitalization,
              onTapOutside: (event) {
                _internalFocusNode.unfocus();
              },
              textInputAction:
                  widget.textInputAction ?? _getDefaultTextInputAction(),
              style: theme.textTheme.bodyLarge,
              decoration: InputDecoration(
                hintText: widget.hint ?? _getDefaultHint(),
                helperText: widget.helperText,
                errorText: widget.errorText,
                prefixIcon: widget.prefixIcon != null
                    ? IconTheme(
                        data: IconThemeData(
                          color: _isFocused
                              ? theme.colorScheme.primary
                              : theme.hintColor,
                        ),
                        child: widget.prefixIcon!,
                      )
                    : null,
                suffixIcon: _buildSuffixIcon(theme),
                contentPadding: widget.contentPadding,
                counter: widget.maxLength != null
                    ? null
                    : const SizedBox.shrink(),
                border: _buildBorder(width: 1, color: _normalBorderColor()),
                enabledBorder: _buildBorder(
                  width: 1,
                  color: _normalBorderColor(),
                ),
                focusedBorder: _buildBorder(
                  width: 2,
                  color: _focusedBorderColor(),
                ),
                disabledBorder: _buildBorder(
                  width: 1,
                  color: _disabledBorderColor(),
                ),
                errorBorder: _buildBorder(width: 1, color: _errorBorderColor()),
                focusedErrorBorder: _buildBorder(
                  width: 2,
                  color: _focusedErrorBorderColor(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget? _buildSuffixIcon(ThemeData theme) {
    // Password visibility toggle
    if (widget.type == AppTextFieldType.password) {
      return IconButton(
        icon: Icon(
          _obscureText
              ? Icons.visibility_rounded
              : Icons.visibility_off_rounded,
          color: _isFocused ? theme.colorScheme.primary : theme.hintColor,
        ),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      );
    }

    // Search clear button
    if (widget.type == AppTextFieldType.search &&
        _internalController.text.isNotEmpty) {
      return IconButton(
        icon: const Icon(Icons.clear_rounded),
        onPressed: () {
          _internalController.clear();
          widget.onClear?.call();
        },
      );
    }

    // Custom suffix icon
    return widget.suffixIcon;
  }

  String? _getDefaultHint() {
    switch (widget.type) {
      case AppTextFieldType.email:
        return 'Enter your email';
      case AppTextFieldType.password:
        return 'Enter your password';
      case AppTextFieldType.search:
        return 'Search...';
      case AppTextFieldType.text:
        return null;
    }
  }

  TextInputAction _getDefaultTextInputAction() {
    switch (widget.type) {
      case AppTextFieldType.email:
        return TextInputAction.next;
      case AppTextFieldType.password:
        return TextInputAction.done;
      case AppTextFieldType.search:
        return TextInputAction.search;
      case AppTextFieldType.text:
        return TextInputAction.done;
    }
  }

  InputBorder _buildBorder({required double width, required Color color}) {
    if (!widget.showBorder) return InputBorder.none;

    return OutlineInputBorder(
      borderRadius: AppRadius.mediumRadius,
      borderSide: BorderSide(color: color, width: width),
    );
  }

  Color _normalBorderColor() {
    return widget.normalBorderColor ??
        widget.borderColor ??
        AppColors.secondaryLight.withValues(alpha: 0.5);
  }

  Color _focusedBorderColor() {
    return widget.focusedBorderColor ?? AppColors.primary;
  }

  Color _errorBorderColor() {
    return widget.errorBorderColor ?? AppColors.error;
  }

  Color _focusedErrorBorderColor() {
    return widget.focusedErrorBorderColor ??
        widget.errorBorderColor ??
        AppColors.error;
  }

  Color _disabledBorderColor() {
    return widget.disabledBorderColor ??
        widget.normalBorderColor ??
        widget.borderColor ??
        AppColors.secondaryLight.withValues(alpha: 0.35);
  }
}
