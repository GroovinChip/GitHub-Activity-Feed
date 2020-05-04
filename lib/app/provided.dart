import 'package:flutter/material.dart';
import 'package:github/github.dart';
import 'package:github_activity_feed/services/auth_service.dart';
import 'package:github_activity_feed/services/github_service.dart';
import 'package:provider/provider.dart';

export 'package:github/github.dart' show CurrentUser;
export 'package:github_activity_feed/services/auth_service.dart' show AuthService;
export 'package:github_activity_feed/services/github_service.dart' show GitHubService;

mixin ProvidedState<T extends StatefulWidget> on State<T> {
  AuthService _authService;
  GitHubService _gitHubService;
  CurrentUser _currentUser;

  AuthService get auth => _authService ??= Provider.of<AuthService>(context, listen: false);
  GitHubService get github => _gitHubService ??= Provider.of<GitHubService>(context, listen: false);
  CurrentUser get user => _currentUser ??= Provider.of<CurrentUser>(context, listen: true);
}
