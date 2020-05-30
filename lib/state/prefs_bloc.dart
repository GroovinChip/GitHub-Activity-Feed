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
    readUserCardPrefs();
  }

  SharedPreferences preferences;

  final userCardOrTile = BehaviorSubject<bool>();

  void close() {
    userCardOrTile.close();
  }

  Future<void> readUserCardPrefs() async {
    bool isCardOrTile = preferences.get('userCardOrTile') ?? true;
    userCardOrTile.add(isCardOrTile);
  }

  Future<void> setUserCardPrefs(bool isCardOrTile) async {
    await preferences.setBool('userCardOrTile', isCardOrTile);
    userCardOrTile.add(isCardOrTile);
  }
}
