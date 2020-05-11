import 'package:flutter/material.dart';
import 'package:github_activity_feed/keys.dart';
import 'package:github_activity_feed/screens/determine_layout.dart';
import 'package:github_activity_feed/screens/login_page.dart';
import 'package:github_activity_feed/services/auth_service.dart';
import 'package:github_activity_feed/services/extensions.dart';
import 'package:github_activity_feed/services/github_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;
import 'package:wiredash/wiredash.dart';

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
      _navigatorKey.currentState.pushAndRemoveUntil(DetermineLayout.route(), (route) => false);
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
      child: Wiredash(
        navigatorKey: _navigatorKey,
        projectId: wiredashProjectId,
        secret: wiredashSecret,
        theme: WiredashThemeData(
          brightness: Brightness.dark,
          primaryColor: Color(0xff2962FF),
          secondaryColor: Color(0xff3BACFF),
        ),
        child: MaterialApp(
          navigatorKey: _navigatorKey,
          title: 'GitHub Activity Feed',
          theme: ThemeData(
            colorScheme: ColorScheme.light().copyWith(
              primary: Color(0xff2962FF),
              primaryVariant: Color(0xff0039cb),
              secondary: Color(0xff3BACFF),
              secondaryVariant: Color(0xff007ecb),
            ),
            // for CircularProgressIndicator and material scroll color
            accentColor: Theme.of(context).colorScheme.secondary,
            textTheme: GoogleFonts.interTextTheme(
              Theme.of(context).textTheme,
            ),
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
              selectedItemColor: context.colorScheme.primary,
              unselectedItemColor: context.colorScheme.onSurface,
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
            // for CircularProgressIndicator and material scroll color
            accentColor: Theme.of(context).colorScheme.secondary,
            textTheme: GoogleFonts.interTextTheme(
              Theme.of(context).textTheme,
            ),
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
              selectedItemColor: context.colorScheme.primary,
              unselectedItemColor: context.colorScheme.onBackground,
            ),
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          themeMode: ThemeMode.system,
          initialRoute: widget.githubService.currentUser.value == null ? LoginPage.routeName : DetermineLayout.routeName,
          onGenerateInitialRoutes: (String initialRoute) => [
            _onGenerateRoute(RouteSettings(name: initialRoute)),
          ],
          onGenerateRoute: _onGenerateRoute,
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }

  Route<dynamic> _onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case DetermineLayout.routeName:
        return DetermineLayout.route(settings: settings);
      case LoginPage.routeName:
        return LoginPage.route(settings: settings);
      default:
        return null;
    }
  }
}
