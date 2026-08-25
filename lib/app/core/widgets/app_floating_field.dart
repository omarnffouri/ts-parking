import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';

class AppFloatingField extends StatefulWidget {
  final String label;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization textCapitalization;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final int? maxLines;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final void Function()? onTap;
  final FocusNode? focusNode;
  final bool _isPassword;

  const AppFloatingField({
    super.key,
    required this.label,
    this.controller,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.prefixIcon,
    this.suffixIcon,
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.none,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.maxLines = 1,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.focusNode,
  }) : _isPassword = false;

  /// Password field with built-in visibility toggle and lock prefix icon.
  const AppFloatingField.password({
    super.key,
    this.label = 'Password',
    this.controller,
    this.validator,
    this.textInputAction,
    this.enabled = true,
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
  }) : _isPassword = true,
       keyboardType = null,
       prefixIcon = const Icon(Icons.lock_outline),
       suffixIcon = null,
       inputFormatters = null,
       textCapitalization = TextCapitalization.none,
       obscureText = true,
       readOnly = false,
       maxLines = 1,
       onTap = null;

  @override
  State<AppFloatingField> createState() => _AppFloatingFieldState();
}

class _AppFloatingFieldState extends State<AppFloatingField> {
  late final FocusNode _focusNode;
  late final bool _isInternalFocusNode;
  late bool _obscureText;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
    _isInternalFocusNode = widget.focusNode == null;
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(() {
      final hasFocus = _focusNode.hasFocus;
      if (_isFocused != hasFocus) {
        setState(() => _isFocused = hasFocus);
      }
    });
  }

  @override
  void dispose() {
    if (_isInternalFocusNode) _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Opacity(
      opacity: widget.enabled ? 1.0 : 0.4,
      child: IgnorePointer(
        ignoring: !widget.enabled,
        child: TextFormField(
          controller: widget.controller,
          focusNode: _focusNode,
          keyboardType: widget.keyboardType,
          obscureText: _obscureText,
          readOnly: widget.readOnly,
          maxLines: widget.maxLines,
          validator: widget.validator,
          onChanged: widget.onChanged,
          onTap: widget.onTap,
          onFieldSubmitted: widget.onSubmitted,
          inputFormatters: widget.inputFormatters,
          textCapitalization: widget.textCapitalization,
          textInputAction: widget.textInputAction,
          onTapOutside: (_) => _focusNode.unfocus(),
          style: theme.textTheme.bodyLarge,
          decoration: InputDecoration(
            labelText: widget.label,
            labelStyle: theme.textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.5),
            ),
            floatingLabelStyle: theme.textTheme.bodyMedium?.copyWith(
              color: _isFocused
                  ? AppColors.primary
                  : colorScheme.onSurface.withValues(alpha: 0.6),
              fontWeight: FontWeight.w500,
            ),
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            prefixIcon: widget.prefixIcon != null
                ? IconTheme(
                    data: IconThemeData(
                      color: _isFocused ? AppColors.primary : theme.hintColor,
                      size: 20,
                    ),
                    child: widget.prefixIcon!,
                  )
                : null,
            suffixIcon: widget._isPassword
                ? IconButton(
                    onPressed: () =>
                        setState(() => _obscureText = !_obscureText),
                    icon: Icon(
                      _obscureText
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: colorScheme.onSurface.withValues(alpha: 0.5),
                      size: 20,
                    ),
                  )
                : widget.suffixIcon,
            filled: true,
            border: _buildBorder(
              color: AppColors.secondaryLight.withValues(alpha: 0.5),
            ),
            enabledBorder: _buildBorder(
              color: AppColors.secondaryLight.withValues(alpha: 0.5),
            ),
            focusedBorder: _buildBorder(color: AppColors.primary, width: 2),
            errorBorder: _buildBorder(color: AppColors.error),
            focusedErrorBorder: _buildBorder(color: AppColors.error, width: 2),
            disabledBorder: _buildBorder(
              color: AppColors.secondaryLight.withValues(alpha: 0.35),
            ),
          ),
        ),
      ),
    );
  }

  InputBorder _buildBorder({required Color color, double width = 1}) {
    return OutlineInputBorder(
      borderRadius: AppRadius.mediumRadius,
      borderSide: BorderSide(color: color, width: width),
    );
  }
}
