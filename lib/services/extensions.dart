import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Some extensions on BuildContext for shorthand access to certain theme properties
extension ThemeExt on BuildContext {
  /*Brightness get brightness => Theme.of(this).brightness;
  TextTheme get textTheme => Theme.of(this).textTheme;
  Color get primaryColor => Theme.of(this).primaryColor;
  Color get primaryColorDark => Theme.of(this).primaryColorDark;
  Color get accentColor => Theme.of(this).accentColor;
  Color get canvasColor => Theme.of(this).canvasColor;
  bool get isDarkTheme => Theme.of(this).brightness == Brightness.dark;*/
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
