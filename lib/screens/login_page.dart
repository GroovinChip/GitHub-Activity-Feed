import 'package:flutter/material.dart';
import 'package:github_activity_feed/app/provided.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;
import 'package:github_activity_feed/services/extensions.dart';

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
  Brightness brightness;
  Color buttonTextColor, buttonIconColor, buttonColor;
  Color textColor;

  @override
  void initState() {
    super.initState();
    auth.startAuth();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    brightness = context.brightness;
    if (brightness == Brightness.light) {
      textColor = Colors.black;
      buttonColor = Colors.black;
      buttonTextColor = Colors.white;
      buttonIconColor = Colors.white;
    } else {
      textColor = Colors.white;
      buttonColor = Colors.white;
      buttonTextColor = Colors.black;
      buttonIconColor = Colors.black;
    }
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
              style: TextStyle(
                color: textColor,
              ),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
              child: _loading
                  ? CircularProgressIndicator()
                  : RaisedButton.icon(
                      label: Text(
                        'Login with GitHub',
                        style: TextStyle(
                          color: buttonTextColor,
                        ),
                      ),
                      icon: Icon(
                        MdiIcons.github,
                        color: buttonIconColor,
                      ),
                      color: buttonColor,
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
