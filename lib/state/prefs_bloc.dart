import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// This rxdart bloc class handles state related to user preferences.
class PrefsBloc {
  PrefsBloc._();

  static Future<PrefsBloc> init() async {
    final bloc = PrefsBloc._();
    await bloc._init();
    return bloc;
  }

  Future<void> _init() async {
    preferences = await SharedPreferences.getInstance();
    readCardOrTilePref();
    readThemeModePref();
  }

  SharedPreferences preferences;

  final cardOrTileSubject = BehaviorSubject<bool>();
  final themeModeSubject = BehaviorSubject<ThemeMode>();

  void close() {
    cardOrTileSubject.close();
    themeModeSubject.close();
  }

  Future<void> setCardOrTilePref(bool isCardOrTile) async {
    await preferences.setBool('userCardOrTile', isCardOrTile);
    cardOrTileSubject.add(isCardOrTile);
  }

  void readCardOrTilePref() {
    bool isCardOrTile = preferences.get('userCardOrTile') ?? true;
    cardOrTileSubject.add(isCardOrTile);
  }

  Future<void> setThemeModePref(ThemeMode themeMode) async {
    await preferences.setString('themeModePref', '${themeMode.toString()}');
    themeModeSubject.add(themeMode);
  }

  void readThemeModePref() {
    String tm = preferences.get('themeModePref') ?? 'ThemeMode.system';
    ThemeMode themeMode = ThemeMode.values.firstWhere((element) => element.toString() == tm);
    themeModeSubject.add(themeMode);
  }
}
