import 'package:flutter/material.dart';

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
