import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:github_activity_feed/keys.dart';
import 'package:github_activity_feed/screens/home_screen.dart';
import 'package:github_activity_feed/screens/login_page.dart';
import 'package:github_activity_feed/services/auth_service.dart';
import 'package:github_activity_feed/services/discovery_service.dart';
import 'package:github_activity_feed/services/github_service.dart';
import 'package:github_activity_feed/services/graphql_service.dart';
import 'package:github_activity_feed/state/prefs_bloc.dart';
import 'package:github_activity_feed/theme/app_themes.dart';
import 'package:github_activity_feed/theme/github_colors.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;
import 'package:wiredash/wiredash.dart';

class GitHubActivityFeedApp extends StatefulWidget {
  const GitHubActivityFeedApp({
    Key key,
    @required this.authService,
    @required this.githubService,
    @required this.prefsBloc,
    @required this.discoveryService,
  }) : super(key: key);

  final AuthService authService;
  final GitHubService githubService;
  final PrefsBloc prefsBloc;
  final DiscoveryService discoveryService;

  @override
  _GitHubActivityFeedAppState createState() => _GitHubActivityFeedAppState();
}

class _GitHubActivityFeedAppState extends State<GitHubActivityFeedApp> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  GraphQLService graphQLService;

  @override
  void initState() {
    super.initState();
    widget.githubService.currentUser.addListener(_onCurrentUserChanged);
    graphQLService =
        GraphQLService(token: widget.githubService.github.auth.token);
  }

  void _onCurrentUserChanged() {
    final currentUser = widget.githubService.currentUser.value;
    if (currentUser == null) {
      _navigatorKey.currentState
          .pushAndRemoveUntil(LoginPage.route(), (route) => false);
    } else {
      try {
        url_launcher.closeWebView();
        _navigatorKey.currentState
                  .pushAndRemoveUntil(HomeScreen.route(), (route) => false);
      } catch (e) {
        final message = 'Post-login crash: $e';
        print(message);
        FirebaseCrashlytics.instance.log(message);
      }
    }
  }

  @override
  void dispose() {
    widget.githubService.currentUser.removeListener(_onCurrentUserChanged);
    widget.githubService.dispose();
    widget.authService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>.value(value: widget.authService),
        Provider<GitHubService>.value(value: widget.githubService),
        ValueListenableProvider.value(value: widget.githubService.currentUser),
        Provider<GraphQLService>.value(value: graphQLService),
        Provider<PrefsBloc>.value(value: widget.prefsBloc),
        Provider<DiscoveryService>.value(value: widget.discoveryService),
      ],
      child: Wiredash(
        navigatorKey: _navigatorKey,
        projectId: wiredashProjectId,
        secret: wiredashSecret,
        theme: WiredashThemeData(
          brightness: Brightness.dark,
          primaryColor: GhColors.blue,
          secondaryColor: GhColors.blue.shade300,
        ),
        options: WiredashOptionsData(),
        child: StreamBuilder<ThemeMode>(
          stream: widget.prefsBloc.themeModeSubject,
          initialData: widget.prefsBloc.themeModeSubject.value,
          builder: (context, snapshot) {
            return MaterialApp(
              navigatorKey: _navigatorKey,
              title: 'GitHub Activity Feed',
              theme: basicLight,
              darkTheme: basicDark,
              themeMode: snapshot.data,
              initialRoute: widget.githubService.currentUser.value == null
                  ? LoginPage.routeName
                  : HomeScreen.routeName,
              onGenerateInitialRoutes: (String initialRoute) => [
                _onGenerateRoute(RouteSettings(name: initialRoute)),
              ],
              onGenerateRoute: _onGenerateRoute,
              debugShowCheckedModeBanner: false,
            );
          },
        ),
      ),
    );
  }

  Route<dynamic> _onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case HomeScreen.routeName:
        return HomeScreen.route(settings: settings);
      case LoginPage.routeName:
        return LoginPage.route(settings: settings);
      default:
        return null;
    }
  }
}
