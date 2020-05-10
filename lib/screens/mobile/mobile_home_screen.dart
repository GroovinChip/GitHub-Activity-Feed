import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:github/github.dart';
import 'package:github_activity_feed/app/provided.dart';
import 'package:github_activity_feed/screens/mobile/mobile_profile.dart';
import 'package:github_activity_feed/screens/widgets/following_users.dart';
import 'package:github_activity_feed/screens/widgets/mobile_activity_feed.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:rxdart/rxdart.dart';

class MobileHomeScreen extends StatefulWidget {
  @override
  _MobileHomeScreenState createState() => _MobileHomeScreenState();
}

class _MobileHomeScreenState extends State<MobileHomeScreen> with ProvidedState {
  int _currentIndex = 0;
  PageController _pageController;

  Stream<Event> activityFeed() =>
      PaginationHelper(github.github).objects('GET', '/users/${user.login}/received_events', (i) => Event.fromJson(i), statusCode: 200);

  Stream<User> listCurrentUserFollowing() => PaginationHelper(github.github).objects('GET', '/user/following', (i) => User.fromJson(i), statusCode: 200);

  final _navItems = [
    BottomNavigationBarItem(
      icon: Icon(MdiIcons.github),
      title: Text('Feed'),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.people_outline),
      title: Text('Following'),
    ),
  ];

  void _handleNavigation(index) {
    setState(() => _currentIndex = index);
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex, keepPage: true);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

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
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => MobileProfile(
                user: user,
              ),
            ),
          ),
        ),
        title: Text(
          'Activity Feed',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: StreamBuilder(
          stream: CombineLatestStream.combine2(
            activityFeed().toList().asStream(),
            listCurrentUserFollowing().toList().asStream(),
            (List<Event> activity, List<User> users) => [activity, users],
          ),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              List<Event> _events = snapshot.data.first;
              List<User> _users = snapshot.data.last;
              final _views = <Widget>[
                MobileActivityFeed(events: _events),
                FollowingUsers(users: _users),
              ];
              return PageTransitionSwitcher(
                transitionBuilder: (
                  Widget child,
                  Animation<double> primaryAnimation,
                  Animation<double> secondaryAnimation,
                ) {
                  return FadeThroughTransition(
                    animation: primaryAnimation,
                    secondaryAnimation: secondaryAnimation,
                    child: child,
                  );
                },
                child: _views[_currentIndex],
              );
            }
          }),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _handleNavigation,
        items: _navItems,
      ),
    );
  }
}
