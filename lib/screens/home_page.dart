import 'package:flutter/material.dart';
import 'package:github_activity_feed/breakpoints.dart';
import 'file:///C:/Users/groov/Flutter_Projects/github_activity_feed/lib/screens/mobile/mobile_activity_feed.dart';
import 'file:///C:/Users/groov/Flutter_Projects/github_activity_feed/lib/screens/tablet/tablet_activity_feed.dart';
import 'file:///C:/Users/groov/Flutter_Projects/github_activity_feed/lib/screens/desktop/desktop_activity_feed.dart';

class HomePage extends StatefulWidget {
  static const routeName = Navigator.defaultRouteName;

  static Route<dynamic> route({
    RouteSettings settings = const RouteSettings(name: routeName),
  }) {
    return MaterialPageRoute(
      settings: settings,
      builder: (BuildContext context) {
        return HomePage();
      },
    );
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth >= kDesktopBreakpoint) {
          return DesktopActivityFeed();
        } else if (constraints.maxWidth >= kTabletBreakpoint) {
          return TabletActivityFeed();
        } else {
          return MobileActivityFeed();
        }
      },
    );
  }
}
