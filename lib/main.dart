import 'package:flutter/material.dart';
import 'package:github_activity_feed/app/app.dart';
import 'package:github_activity_feed/services/auth_service.dart';
import 'package:github_activity_feed/services/github_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final authService = await AuthService.init();
  final githubService = await GitHubService.init(authService);
  runApp(GitHubActivityFeedApp(
    authService: authService,
    githubService: githubService,
  ));
}
