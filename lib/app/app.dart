import 'package:flutter/material.dart';
import 'package:github_activity_feed/keys.dart';
import 'package:github_activity_feed/screens/login_page.dart';
import 'package:github_activity_feed/screens/home_screen.dart';
import 'package:github_activity_feed/services/auth_service.dart';
import 'file:///C:/Users/groov/Flutter_Projects/github_activity_feed/lib/utils/extensions.dart';
import 'package:github_activity_feed/services/gh_gql_query_service.dart';
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
  GhGraphQLService ghQueryService;

  @override
  void initState() {
    super.initState();
    widget.githubService.currentUser.addListener(_onCurrentUserChanged);
    ghQueryService = GhGraphQLService(token: widget.githubService.github.auth.token);
  }

  void _onCurrentUserChanged() {
    final currentUser = widget.githubService.currentUser.value;
    if (currentUser == null) {
      _navigatorKey.currentState.pushAndRemoveUntil(LoginPage.route(), (route) => false);
    } else {
      url_launcher.closeWebView();
      _navigatorKey.currentState.pushAndRemoveUntil(HomeScreen.route(), (route) => false);
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
        Provider<GhGraphQLService>.value(value: ghQueryService),
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
            brightness: Brightness.light,
            colorScheme: ColorScheme.light().copyWith(
              primary: Color(0xff2962FF),
              primaryVariant: Color(0xff0039cb),
              secondary: Color(0xff3BACFF),
              secondaryVariant: Color(0xff007ecb),
            ),
            primaryColor: Color(0xff2962FF),
            // for CircularProgressIndicator and material scroll color
            accentColor: Color(0xff3BACFF),
            textTheme: GoogleFonts.interTextTheme(
              ThemeData.light().textTheme,
            ),
            appBarTheme: AppBarTheme(
              color: Color(0xff2962FF),
            ),
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
              selectedItemColor: context.colorScheme.primary,
              unselectedItemColor: context.colorScheme.onSurface,
            ),
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            colorScheme: ColorScheme.dark().copyWith(
              primary: Color(0xff2962FF),
              primaryVariant: Color(0xff0039cb),
              secondary: Color(0xff3BACFF),
              secondaryVariant: Color(0xff007ecb),
            ),
            primaryColor: Color(0xff2962FF),
            // for CircularProgressIndicator and material scroll color
            accentColor: Color(0xff3BACFF),
            canvasColor: ColorScheme.dark().background,
            textTheme: GoogleFonts.interTextTheme(
              ThemeData.dark().textTheme,
            ),
            appBarTheme: AppBarTheme(
              color: Colors.black,
            ),
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
              selectedItemColor: context.colorScheme.primary,
              unselectedItemColor: context.colorScheme.onBackground,
            ),
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          themeMode: ThemeMode.system,
          initialRoute: widget.githubService.currentUser.value == null
              ? LoginPage.routeName
              : HomeScreen.routeName,
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
      case HomeScreen.routeName:
        return HomeScreen.route(settings: settings);
      case LoginPage.routeName:
        return LoginPage.route(settings: settings);
      default:
        return null;
    }
  }
}
