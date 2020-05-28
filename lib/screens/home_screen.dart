import 'package:flutter/material.dart';
import 'package:github_activity_feed/app/provided.dart';
import 'package:github_activity_feed/screens/search_screen.dart';
import 'package:github_activity_feed/screens/user_overview.dart';
import 'package:github_activity_feed/widgets/activity_feed.dart';
import 'package:github_activity_feed/widgets/following_users.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = Navigator.defaultRouteName;

  static Route<dynamic> route({
    RouteSettings settings = const RouteSettings(name: routeName),
  }) {
    return MaterialPageRoute(
      settings: settings,
      builder: (BuildContext context) {
        return HomeScreen();
      },
    );
  }

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with ProvidedState {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkResponse(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: CircleAvatar(
              backgroundImage: NetworkImage(user.avatarUrl),
            ),
          ),
          onTap: () {
            return Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => UserOverview(
                  login: user.login,
                  isViewer: true,
                ),
              ),
            );
          },
        ),
        title: Text(
          'Activity Feed',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () => showSearch(
              context: context,
              delegate: SearchScreen(
                gitHub: githubService.github,
              ),
            ),
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          ActivityFeed(),
          ViewerFollowingList(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(MdiIcons.github),
            title: Text('Feed'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            title: Text('Following'),
          ),
        ],
      ),
    );
  }
}
