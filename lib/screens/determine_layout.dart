import 'package:flutter/material.dart';
import 'package:github_activity_feed/breakpoints.dart';
import 'package:github_activity_feed/screens/desktop/desktop_activity_feed.dart';
import 'package:github_activity_feed/screens/mobile/mobile_home_screen.dart';
import 'package:github_activity_feed/screens/tablet/tablet_activity_feed.dart';

class DetermineLayout extends StatefulWidget {
  static const routeName = Navigator.defaultRouteName;

  static Route<dynamic> route({
    RouteSettings settings = const RouteSettings(name: routeName),
  }) {
    return MaterialPageRoute(
      settings: settings,
      builder: (BuildContext context) {
        return DetermineLayout();
      },
    );
  }

  @override
  _DetermineLayoutState createState() => _DetermineLayoutState();
}

class _DetermineLayoutState extends State<DetermineLayout> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth >= kDesktopBreakpoint) {
          return DesktopActivityFeed();
        } else if (constraints.maxWidth >= kTabletBreakpoint) {
          return TabletActivityFeed();
        } else {
          return MobileHomeScreen();
        }
      },
    );
  }
}
