enum LessonTypeName {
  theory,
  practical,
  roadTest,
  parkingTest,
  assessmentTest;

  String get displayName {
    switch (this) {
      case LessonTypeName.theory:
        return 'Theory';
      case LessonTypeName.practical:
        return 'Practical';
      case LessonTypeName.roadTest:
        return 'Road Test';
      case LessonTypeName.parkingTest:
        return 'Parking Test';
      case LessonTypeName.assessmentTest:
        return 'Assessment Test';
    }
  }

  // Helper to parse from string case-insensitive and handling underscores
  static LessonTypeName fromString(String value) {
    if (value.isEmpty) return LessonTypeName.practical;
    final normalized = value.toUpperCase().replaceAll(' ', '_');

    // Explicit mappings for common variations
    if (normalized.contains('AUTOMATIC') ||
        normalized.contains('MANUAL') ||
        normalized == 'DRIVING' ||
        normalized == 'DRIVING_LESSON') {
      return LessonTypeName.practical;
    }
    if (normalized == 'THEORY') return LessonTypeName.theory;
    if (normalized.contains('ROAD')) return LessonTypeName.roadTest;
    if (normalized.contains('PARKING')) return LessonTypeName.parkingTest;
    if (normalized.contains('ASSESSMENT') || normalized.contains('MOCK')) {
      return LessonTypeName.assessmentTest;
    }

    try {
      return LessonTypeName.values.firstWhere(
        (e) =>
            e.name.toUpperCase() == normalized ||
            e.displayName.toUpperCase().replaceAll(' ', '_') == normalized,
      );
    } catch (_) {
      // Default fallback
      return LessonTypeName.practical;
    }
  }
}
