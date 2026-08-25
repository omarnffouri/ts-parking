import 'package:flutter/services.dart';

/// Formats mobile number input as XXX-XXX-XXXX (3-3-4 pattern).
/// Only allows digits, auto-inserts dashes.
class MobileInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digitsOnly = newValue.text.replaceAll(RegExp(r'\D'), '');

    final trimmed = digitsOnly.length > 10
        ? digitsOnly.substring(0, 10)
        : digitsOnly;

    final buffer = StringBuffer();
    for (int i = 0; i < trimmed.length; i++) {
      if (i == 3 || i == 6) {
        buffer.write('-');
      }
      buffer.write(trimmed[i]);
    }

    final formatted = buffer.toString();

    int cursorOffset = newValue.selection.baseOffset;
    int digitsBefore = newValue.text
        .substring(0, cursorOffset.clamp(0, newValue.text.length))
        .replaceAll(RegExp(r'\D'), '')
        .length;

    int newCursor = 0;
    int digitCount = 0;
    for (int i = 0; i < formatted.length; i++) {
      if (digitCount == digitsBefore) break;
      newCursor++;
      if (formatted[i] != '-') {
        digitCount++;
      }
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(
        offset: newCursor.clamp(0, formatted.length),
      ),
    );
  }
}
