import 'package:flutter/material.dart';
import 'package:github/github.dart';
import 'package:github_activity_feed/app/provided.dart';
import 'package:github_activity_feed/screens/mobile/mobile_settings.dart';
import 'package:github_activity_feed/screens/widgets/following_users.dart';
import 'package:github_activity_feed/screens/widgets/mobile_activity_feed.dart';
import 'package:github_activity_feed/services/extensions.dart';
import 'package:groovin_widgets/avatar_back_button.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:rxdart/rxdart.dart';

class MobileProfile extends StatefulWidget {
  MobileProfile({
    Key key,
    @required this.user,
  }) : super(key: key);

  final User user;

  @override
  _MobileProfileState createState() => _MobileProfileState();
}

class _MobileProfileState extends State<MobileProfile> with ProvidedState, SingleTickerProviderStateMixin {
  User get _currentUser => widget.user;

  TabController _tabController;

  Stream<User> listCurrentUserFollowing() => PaginationHelper(github.github).objects('GET', '/user/following', (i) => User.fromJson(i), statusCode: 200);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(initialIndex: 0, length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _currentUser.login,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                _currentUser.email != null
                    ? Text(
                        _currentUser.email,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                      )
                    : Container(),
              ],
            ),
          ],
        ),
        actions: [
          if (_currentUser.login == user.login)
            IconButton(
              icon: Icon(
                MdiIcons.cogOutline,
                color: context.colorScheme.secondary,
              ),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => MobileSettings()),
              ),
            ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: context.colorScheme.secondary,
          tabs: [
            Tab(text: 'Overview'),
            Tab(text: 'Activity'),
          ],
        ),
      ),
      body: StreamBuilder(
        stream: CombineLatestStream.list([
          github.github.repositories.listRepositories().toList().asStream(),
          listCurrentUserFollowing().toList().asStream(),
          github.github.users.listCurrentUserFollowers().toList().asStream(),
          github.github.activity.listStarred().toList().asStream(),
          github.github.activity.listEventsPerformedByUser(_currentUser.login).toList().asStream(),
          github.github.organizations.list().toList().asStream(),
        ]),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(context.colorScheme.secondary),
              ),
            );
          } else {
            List<Repository> _repositories = snapshot.data[0];
            List<User> _following = snapshot.data[1];
            List<User> _followers = snapshot.data[2];
            List<Repository> _starred = snapshot.data[3];
            List<Event> _activity = snapshot.data[4];
            List<Organization> _organizations = snapshot.data[5];
            return TabBarView(
              controller: _tabController,
              children: [
                ListView(
                  children: [
                    if (_currentUser.bio != null)
                      ListTile(
                        title: Text(
                          _currentUser.bio,
                          style: TextStyle(color: context.colorScheme.onBackground),
                        ),
                      ),
                    if (_currentUser.location != null)
                      ListTile(
                        leading: Icon(MdiIcons.mapMarkerOutline),
                        title: Text(
                          _currentUser.location,
                          style: TextStyle(color: context.colorScheme.onBackground),
                        ),
                      ),
                    if (_currentUser.email != null)
                      ListTile(
                        leading: Icon(Icons.access_time),
                        title: Text(
                          _currentUser.createdAt.toString(),
                          style: TextStyle(color: context.colorScheme.onBackground),
                        ),
                      ),
                    Divider(height: 0),
                    ListTile(
                      title: Text(
                        'Repositories',
                        style: TextStyle(color: context.colorScheme.onBackground),
                      ),
                      trailing: Text(
                        '${_repositories.length}',
                        style: TextStyle(
                          color: context.colorScheme.onBackground,
                        ),
                      ),
                      onTap: () {},
                    ),
                    ListTile(
                      title: Text(
                        'Following',
                        style: TextStyle(color: context.colorScheme.onBackground),
                      ),
                      trailing: Text(
                        '${_following.length}',
                        style: TextStyle(
                          color: context.colorScheme.onBackground,
                        ),
                      ),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => Scaffold(
                            appBar: AppBar(),
                            body: FollowingUsers(users: _following),
                          ),
                        ),
                      ),
                    ),
                    ListTile(
                      title: Text(
                        'Followers',
                        style: TextStyle(color: context.colorScheme.onBackground),
                      ),
                      trailing: Text(
                        '${_followers.length}',
                        style: TextStyle(
                          color: context.colorScheme.onBackground,
                        ),
                      ),
                      onTap: () {},
                    ),
                    ListTile(
                      title: Text(
                        'Starred',
                        style: TextStyle(color: context.colorScheme.onBackground),
                      ),
                      trailing: Text(
                        '${_starred.length}',
                        style: TextStyle(color: context.colorScheme.onBackground),
                      ),
                      onTap: () {},
                    ),
                    ListTile(
                      title: Text(
                        'Organizations',
                        style: TextStyle(color: context.colorScheme.onBackground),
                      ),
                      trailing: Text(
                        '${_organizations.length}',
                        style: TextStyle(color: context.colorScheme.onBackground),
                      ),
                      onTap: () {},
                    ),
                  ],
                ),
                MobileActivityFeed(
                  events: _activity,
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
