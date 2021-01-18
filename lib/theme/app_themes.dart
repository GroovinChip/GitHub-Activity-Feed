import 'package:flutter/material.dart';
import 'package:github_activity_feed/theme/github_colors.dart';
import 'package:google_fonts/google_fonts.dart';

/// A custom dark application theme that uses colors defined in [GhColors]
final darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: GhColors.blue,
  accentColor: GhColors.blue.shade300,
  canvasColor: GhColors.grey.shade900,
  textTheme: GoogleFonts.interTextTheme(
    ThemeData.dark().textTheme,
  ),
  appBarTheme: AppBarTheme(
    centerTitle: true,
    color: GhColors.grey.shade900,
    elevation: 0,
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: GhColors.grey.shade900,
    selectedItemColor: GhColors.blue,
    unselectedItemColor: Colors.white,
  ),
  visualDensity: VisualDensity.adaptivePlatformDensity,
  dividerColor: GhColors.grey,
);
