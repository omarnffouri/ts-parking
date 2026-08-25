extension DoubleFormatExtensions on double {
  String toPrice() {
    final hasDecimals = this % 1 != 0;
    return '\$${toStringAsFixed(hasDecimals ? 2 : 0)}';
  }
}

extension StringExtensions on String {
  String toTitleCase() {
    final trimmed = trim();
    if (trimmed.isEmpty) return this;
    return trimmed
        .split(RegExp(r'\s+'))
        .map(
          (word) => word.isEmpty
              ? word
              : '${word[0].toUpperCase()}${word.substring(1)}',
        )
        .join(' ');
  }

  String toCompactInitials({int maxLength = 2}) {
    final words = trim()
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .toList(growable: false);

    if (words.isEmpty) return '';
    if (words.length == 1 && words.first.length <= maxLength) {
      return words.first.toUpperCase();
    }

    final initials = words
        .map((word) => word.substring(0, 1).toUpperCase())
        .join();

    return initials.isEmpty
        ? this
        : initials.substring(
            0,
            initials.length > maxLength ? maxLength : initials.length,
          );
  }
}
