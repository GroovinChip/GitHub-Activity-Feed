import 'package:flutter/material.dart';
import 'package:github_activity_feed/screens/home_page.dart';
import 'package:github_activity_feed/screens/login_page.dart';
import 'package:github_activity_feed/services/auth_service.dart';
import 'package:github_activity_feed/services/github_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;
import 'package:github_activity_feed/services/extensions.dart';

class GitHubActivityFeedApp extends StatefulWidget {
  const GitHubActivityFeedApp({
    Key key,
    @required this.authService,
    @required this.githubService,
  }) : super(key: key);

  final AuthService authService;
  final GitHubService githubService;

  @override
  _GitHubActivityFeedAppState createState() => _GitHubActivityFeedAppState();
}

class _GitHubActivityFeedAppState extends State<GitHubActivityFeedApp> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    widget.githubService.currentUser.addListener(_onCurrentUserChanged);
  }

  void _onCurrentUserChanged() {
    final currentUser = widget.githubService.currentUser.value;
    if (currentUser == null) {
      _navigatorKey.currentState.pushAndRemoveUntil(LoginPage.route(), (route) => false);
    } else {
      url_launcher.closeWebView();
      _navigatorKey.currentState.pushAndRemoveUntil(HomePage.route(), (route) => false);
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
      ],
      child: MaterialApp(
        navigatorKey: _navigatorKey,
        title: 'Github Auth Test',
        theme: ThemeData(
          colorScheme: ColorScheme.light().copyWith(
            primary: Color(0xff2962FF),
            primaryVariant: Color(0xff0039cb),
            secondary: Color(0xff3BACFF),
            secondaryVariant: Color(0xff007ecb),
          ),
          textTheme: GoogleFonts.interTextTheme(
            Theme.of(context).textTheme,
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        darkTheme: ThemeData.dark().copyWith(
          colorScheme: ColorScheme.dark().copyWith(
            primary: Color(0xff2962FF),
            primaryVariant: Color(0xff0039cb),
            secondary: Color(0xff3BACFF),
            secondaryVariant: Color(0xff007ecb),
          ),
          textTheme: GoogleFonts.interTextTheme(
            Theme.of(context).textTheme,
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        themeMode: ThemeMode.system,
        initialRoute: widget.githubService.currentUser.value == null
            ? LoginPage.routeName
            : HomePage.routeName,
        onGenerateInitialRoutes: (String initialRoute) => [
          _onGenerateRoute(RouteSettings(name: initialRoute)),
        ],
        onGenerateRoute: _onGenerateRoute,
        debugShowCheckedModeBanner: false,
      ),
    );
  }

  Route<dynamic> _onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case HomePage.routeName:
        return HomePage.route(settings: settings);
      case LoginPage.routeName:
        return LoginPage.route(settings: settings);
      default:
        return null;
    }
  }
}
