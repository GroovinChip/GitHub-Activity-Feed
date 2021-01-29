import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension ThemeX on BuildContext {
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  ThemeData get theme => Theme.of(this);
  bool get isDarkTheme =>
      Theme.of(this).colorScheme.brightness == Brightness.dark;
  Color get onSurface => Theme.of(this).colorScheme.onSurface;
}

extension DateTimeX on DateTime {
  /// Formats a [DateTime] as mm/dd/yy
  String get asMonthDayYear => DateFormat.yMMMMd('en_US').format(this);
}

extension ThemeModeX on ThemeMode {
  String format() {
    String themeModeString;
    switch (this) {
      case ThemeMode.system:
        themeModeString = 'System theme';
        break;
      case ThemeMode.light:
        themeModeString = 'Light theme';
        break;
      case ThemeMode.dark:
        themeModeString = 'Dark theme';
        break;
    }
    return themeModeString;
  }

  bool get isSystemMode => this == ThemeMode.system;
  bool get isDarkMode => this == ThemeMode.dark;
  bool get isLightMode => this == ThemeMode.light;
}

extension StringX on String {
  bool get isNullOrEmpty => this == null || this.isEmpty;

  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }

  /// Returns true if string is:
  /// - null
  /// - empty
  /// - whitespace string.
  ///
  /// Characters considered "whitespace" are listed [here](https://stackoverflow.com/a/59826129/10830091).
  bool get isNullEmptyOrWhitespace =>
      this == null || this.isEmpty || this.trim().isEmpty;
}

extension ListX on List {
  /// Returns true if string is:
  /// - null
  /// - empty
  /// - whitespace string.
  ///
  /// Characters considered "whitespace" are listed [here](https://stackoverflow.com/a/59826129/10830091).
  bool get isNullOrEmpty => this == null || this.isEmpty;
}
