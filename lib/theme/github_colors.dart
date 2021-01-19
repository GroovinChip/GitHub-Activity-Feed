import 'package:flutter/material.dart';

/// A custom color class to use GitHub color swatches.
///
/// Mimics the behavior of [MaterialColor] in that it accepts
/// a primary color value and a color swatch, and provices
/// shade getters.
class GitHubColor extends ColorSwatch<int> {
  const GitHubColor(
    int primary,
    Map<int, Color> swatch,
  ) : super(primary, swatch);

  /// The lightest shade.
  Color get shadeZero => this[0];

  /// The second lightest shade.
  Color get shade100 => this[100];

  /// The third lightest shade.
  Color get shade200 => this[200];

  /// The fourth lightest shade.
  Color get shade300 => this[300];

  /// The fifth lightest shade.
  Color get shade400 => this[400];

  /// The default shade.
  Color get shade500 => this[500];

  /// The fourth darkest shade.
  Color get shade600 => this[600];

  /// The third darkest shade.
  Color get shade700 => this[700];

  /// The second darkest shade.
  Color get shade800 => this[800];

  /// The darkest shade.
  Color get shade900 => this[900];
}

/// Color swatches defined by GitHub's color system.
///
/// See https://primer.style/css/support/color-system
class GhColors {
  /// GitHub grey swatch
  static const GitHubColor grey = GitHubColor(
    0xff6a737d,
    <int, Color>{
      0: Color(0xfffafbfc),
      100: Color(0xfff6f8fa),
      200: Color(0xffe1e4e8),
      300: Color(0xffd1d5da),
      400: Color(0xff959da5),
      500: Color(0xff6a737d),
      600: Color(0xff586069),
      700: Color(0xff444d56),
      800: Color(0xff2f363d),
      900: Color(0xff24292e),
    },
  );

  /// GitHub blue swatch
  static const GitHubColor blue = GitHubColor(
    0xff0366d6,
    <int, Color>{
      0: Color(0xfff1f8ff),
      100: Color(0xffdbedff),
      200: Color(0xffc8e1ff),
      300: Color(0xff79b8ff),
      400: Color(0xff2188ff),
      500: Color(0xff0366d6),
      600: Color(0xff005cc5),
      700: Color(0xff044289),
      800: Color(0xff032f62),
      900: Color(0xff05264c),
    },
  );

  /// GitHub green swatch
  static const GitHubColor green = GitHubColor(
    0xff28a745,
    <int, Color>{
      0: Color(0xfff0fff4),
      100: Color(0xffdcffe4),
      200: Color(0xffbef5cb),
      300: Color(0xff85e89d),
      400: Color(0xff34d058),
      500: Color(0xff28a745),
      600: Color(0xff22863a),
      700: Color(0xff176f2c),
      800: Color(0xff165c26),
      900: Color(0xff144620),
    },
  );

  /// GitHub purple swatch
  static const GitHubColor purple = GitHubColor(
    0xff6f42c1,
    <int, Color>{
      0: Color(0xfff5f0ff),
      100: Color(0xffe6dcfd),
      200: Color(0xffd1bcf9),
      300: Color(0xffb392f0),
      400: Color(0xff8a63d2),
      500: Color(0xff6f42c1),
      600: Color(0xff5a32a3),
      700: Color(0xff4c2889),
      800: Color(0xff3a1d6e),
      900: Color(0xff29134e),
    },
  );

  /// GitHub yellow swatch
  static const GitHubColor yellow = GitHubColor(
    0xffffd33d,
    <int, Color>{
      0: Color(0xfffffdef),
      100: Color(0xfffffbdd),
      200: Color(0xfffff5b1),
      300: Color(0xffffea7f),
      400: Color(0xffffdf5d),
      500: Color(0xffffd33d),
      600: Color(0xfff9c513),
      700: Color(0xffdbab09),
      800: Color(0xffb08800),
      900: Color(0xff735c0f),
    },
  );

  /// GitHub orange swatch
  static const GitHubColor orange = GitHubColor(
    0xfff66a0a,
    <int, Color>{
      0: Color(0xfffff8f2),
      100: Color(0xffffebda),
      200: Color(0xffffd1ac),
      300: Color(0xffffab70),
      400: Color(0xfffb8532),
      500: Color(0xfff66a0a),
      600: Color(0xffe36209),
      700: Color(0xffd15704),
      800: Color(0xffc24e00),
      900: Color(0xffa04100),
    },
  );

  /// GitHub red swatch
  static const GitHubColor red = GitHubColor(
    0xffd73a49,
    <int, Color>{
      0: Color(0xffffeef0),
      100: Color(0xffffdce0),
      200: Color(0xfffdaeb7),
      300: Color(0xfff97583),
      400: Color(0xffea4a5a),
      500: Color(0xffd73a49),
      600: Color(0xffcb2431),
      700: Color(0xffb31d28),
      800: Color(0xff9e1c23),
      900: Color(0xff86181d),
    },
  );

  /// GitHub pink swatch
  static const GitHubColor pink = GitHubColor(
    0xffea4aaa,
    <int, Color>{
      0: Color(0xffffeef8),
      100: Color(0xfffedbf0),
      200: Color(0xfff9b3dd),
      300: Color(0xfff692ce),
      400: Color(0xffec6cb9),
      500: Color(0xffea4aaa),
      600: Color(0xffd03592),
      700: Color(0xffb93a86),
      800: Color(0xff99306f),
      900: Color(0xff6d224f),
    },
  );
}
