import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Some extensions on BuildContext for shorthand access to certain theme properties
extension ThemeExt on BuildContext {
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  bool get isDarkTheme => Theme.of(this).colorScheme.brightness == Brightness.dark;
}

extension DateTimeFormattingX on DateTime {
  String get asMonthDayYear => DateFormat.yMMMMd('en_US').format(this);
}

extension StringCheckX on String {
  bool get isNullOrEmpty => this == null || this.isEmpty;
}

extension StringX on String {
  String replaceAfter(String delimiter, String replacement, [String defaultValue]) {
    final index = indexOf(delimiter);
    return (index == -1) ? defaultValue.isNullOrEmpty ? this : defaultValue : replaceRange(index + 1, length, replacement);
  }

  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}

extension TextUtilsStringExtension on String {
  /// Returns true if string is:
  /// - null
  /// - empty
  /// - whitespace string.
  ///
  /// Characters considered "whitespace" are listed [here](https://stackoverflow.com/a/59826129/10830091).
  bool get isNullEmptyOrWhitespace =>
      this == null || this.isEmpty || this.trim().isEmpty;
}

extension ListUtilsStringExtension on List {
  /// Returns true if string is:
  /// - null
  /// - empty
  /// - whitespace string.
  ///
  /// Characters considered "whitespace" are listed [here](https://stackoverflow.com/a/59826129/10830091).
  bool get isNullOrEmpty =>
      this == null || this.isEmpty;
}