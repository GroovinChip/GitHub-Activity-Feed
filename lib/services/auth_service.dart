import 'dart:async';
import 'dart:convert' show json;
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:github/github.dart';
import 'package:github_activity_feed/keys.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as pp;
import 'package:uuid/uuid.dart';

class AuthService {
  AuthService._();

  static Future<AuthService> init() async {
    final service = AuthService._();
    await service._init();
    return service;
  }

  Future<void> _init() async {
    _stateFile = File(path.join(
        (await pp.getApplicationDocumentsDirectory()).path, 'auth.json'));

    Map<String, dynamic> data;
    if (_stateFile.existsSync()) {
      data = json.decode(await _stateFile.readAsString());
    }
    _stateId = data != null ? data['state_id'] : null;
    _authState =
        data != null ? AuthState._(data['access_token']) : AuthState.loggedOut;

    await _updateStateListener();
  }

  final _firestore = FirebaseFirestore.instance;
  final _onAuthStateChanged = StreamController<AuthState>.broadcast();

  File _stateFile;
  String _stateId;
  OAuth2Flow _oAuth2Flow;
  AuthState _authState = AuthState.loggedOut;
  DocumentReference _redirectRef;
  StreamSubscription<DocumentSnapshot> _redirectSub;

  String get authUrl => _oAuth2Flow.createAuthorizeUrl();

  AuthState get authState => _authState;

  Stream<AuthState> get onAuthStateChanged => _onAuthStateChanged.stream;

  Future<void> startAuth() async {
    _stateId = Uuid().v4();
    _oAuth2Flow = OAuth2Flow(
      clientId,
      clientSecret,
      state: _stateId,
      scopes: [
        'user',
        'public_repo',
        'repo',
        'repo_deployment',
        'repo:status',
        'read:repo_hook',
        'read:org',
        'read:public_key',
        'read:gpg_key',
      ],
      redirectUri: 'https://github-activity-feed.web.app/auth_redirect',
    );
    await _redirectRef?.delete();
    await _updateStateFile();
    await _updateStateListener();
  }

  void dispose() {
    _redirectSub?.cancel();
  }

  Future<void> _updateStateFile() async {
    _stateFile.writeAsString(
      json.encode({
        'state_id': _stateId,
        'access_token': _authState.accessToken,
      }),
    );
  }

  Future<void> _updateStateListener() async {
    await _redirectSub?.cancel();
    if (_stateId != null) {
      _redirectRef = _firestore.doc('redirects/$_stateId');
      await _redirectRef.set({'state': 'waiting'});
      _redirectSub = _redirectRef.snapshots().listen(_onCodeUpdated);
    }
  }

  Future<void> _onCodeUpdated(DocumentSnapshot snapshot) async {
    // print('_onCodeUpdated: ${snapshot.documentID}: ${snapshot.data}');
    if (!snapshot.exists) {
      // document was deleted
      return;
    }
    final state = snapshot.data()['state'];
    if (state != 'authorized') {
      return;
    }
    final code = snapshot.data()['code'];
    if (code == null) {
      return;
    }
    try {
      final response = await _oAuth2Flow.exchange(code);
      _authState = AuthState._(response.token);
      _onAuthStateChanged.add(_authState);
      await _updateStateFile();
      await _redirectRef.delete();
    } catch (error) {
      print('Auth Error: $error');
      logOut();
    }
  }

  Future<void> logOut() async {
    await _redirectRef.delete();
    _authState = AuthState.loggedOut;
    _onAuthStateChanged.add(AuthState.loggedOut);
    await _updateStateFile();
  }
}

class AuthState {
  static const loggedOut = AuthState._(null);

  const AuthState._(this.accessToken);

  final String accessToken;
}
