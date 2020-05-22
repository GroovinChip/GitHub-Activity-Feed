import 'dart:async';

import 'package:flutter/material.dart';
import 'package:github/github.dart';
import 'package:github_activity_feed/app/provided.dart';
import 'package:github_activity_feed/screens/settings_screen.dart';
import 'package:github_activity_feed/services/extensions.dart';
import 'package:github_activity_feed/widgets/activity_feed.dart';
import 'package:github_activity_feed/widgets/user_profile.dart';
import 'package:github_activity_feed/widgets/view_in_browser_button.dart';
import 'package:groovin_widgets/avatar_back_button.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class UserOverview extends StatefulWidget {
  UserOverview({
    Key key,
    @required this.user,
  }) : super(key: key);

  final User user;

  @override
  _UserOverviewState createState() => _UserOverviewState();
}

class _UserOverviewState extends State<UserOverview> with ProvidedState {
  Stream<List<Event>> _events;
  int _currentIndex = 0;

  User get _currentUser => widget.user;

 @override
  void initState() {
    super.initState();
    _events = githubService.github.activity
        .listEventsPerformedByUser(_currentUser.login)
        .toList()
        .asStream();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 8,
        title: Row(
          children: [
            AvatarBackButton(
              avatar: _currentUser.avatarUrl,
              onPressed: () => Navigator.pop(context),
            ),
            SizedBox(width: 16),
            Text(
              _currentUser.login,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          ViewInBrowserButton(url: 'https://github.com/${_currentUser.login}'),
          if (_currentUser.login == user.login)
            IconButton(
              icon: Icon(
                MdiIcons.cogOutline,
                color: context.colorScheme.secondary,
              ),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              ),
            ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          ActivityFeed(events: _events),
          UserProfile(currentUser: _currentUser),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(MdiIcons.github),
            title: Text('Activity'),
          ),
          BottomNavigationBarItem(
            icon: Icon(MdiIcons.accountOutline),
            title: Text('Profile'),
          ),
        ],
      ),
    );
  }
}
