import 'package:flutter/material.dart';
import 'package:github_activity_feed/app/provided.dart';
import 'package:github_activity_feed/utils/extensions.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

class LoginPage extends StatefulWidget {
  static const routeName = '/login';

  static Route<dynamic> route({
    RouteSettings settings = const RouteSettings(name: routeName),
  }) {
    return MaterialPageRoute(
      settings: settings,
      builder: (BuildContext context) {
        return LoginPage();
      },
    );
  }

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with ProvidedState {
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    auth.startAuth();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'GitHub Activity Feed',
              style: Theme.of(context).textTheme.headline4.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            SizedBox(height: 52),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
              child: _loading
                  ? CircularProgressIndicator()
                  : RaisedButton.icon(
                      color: context.isDarkTheme ? Colors.white : Colors.black,
                      textColor: context.colorScheme.onPrimary,
                      label: Text('Sign in with GitHub'),
                      icon: Icon(MdiIcons.github),
                      onPressed: () {
                        setState(() => _loading = true);
                        url_launcher.launch(
                          auth.authUrl,
                          forceWebView: true,
                          enableJavaScript: true,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
