import 'package:flutter/material.dart';
import 'package:github/github.dart';
import 'package:github_activity_feed/app/provided.dart';
import 'package:github_activity_feed/screens/repository_list.dart';
import 'package:github_activity_feed/services/extensions.dart';
import 'package:github_activity_feed/utils/navigation_util.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:github_activity_feed/utils/prettyJson.dart';

class UserProfile extends StatefulWidget {
  final User currentUser;

  const UserProfile({
    Key key,
    @required this.currentUser,
  }) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> with ProvidedState {
  int _starredCount;

  Future<bool> _checkIsFollowingUser() async {
    if (widget.currentUser.login != user.login) {
      return githubService.github.users.isFollowingUser(widget.currentUser.login);
    } else {
      return false;
    }
  }

  void _getStarredCount() {
    githubService.github.activity.listStarredByUser(widget.currentUser.login).toList().then((List<Repository> starred) {
      setState(() => _starredCount = starred.length);
    });
  }

  @override
  void initState() {
    super.initState();
    _getStarredCount();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle.merge(
      style: Theme.of(context).textTheme.subtitle1,
      child: FutureBuilder<User>(
          future: githubService.github.users.getUser(widget.currentUser.login),
          builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              final _user = snapshot.data;
              return Column(
                children: [
                  if (_user.bio != null)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: ListTile(
                          title: Text(_user.bio),
                        ),
                      ),
                    ),
                  if (!_user.company.isNullOrEmpty)
                    ListTile(
                      leading: Icon(MdiIcons.officeBuilding),
                      title: Text(_user.company),
                    ),
                  if (!_user.location.isNullOrEmpty)
                    ListTile(
                      leading: Icon(MdiIcons.mapMarkerOutline),
                      title: Text(_user.location),
                    ),
                  if (_user.blog.isNotEmpty)
                    ListTile(
                      leading: Icon(MdiIcons.link),
                      title: Text(_user.blog),
                    ),
                  if (_user.createdAt != null)
                    ListTile(
                      leading: Icon(Icons.access_time),
                      title: Text(_user.createdAt.asMonthDayYear),
                    ),
                  if (_user.login != user.login)
                    Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: FutureBuilder<bool>(
                              future: _checkIsFollowingUser(),
                              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                                if (!snapshot.hasData) {
                                  return IgnorePointer(
                                    child: RaisedButton(
                                      child: Text('...'),
                                      onPressed: () {},
                                    ),
                                  );
                                } else {
                                  return RaisedButton.icon(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    icon: Icon(!snapshot.data
                                        ? MdiIcons.accountPlusOutline
                                        : MdiIcons.accountMinusOutline),
                                    label: Text(!snapshot.data ? 'Follow' : 'Unfollow'),
                                    onPressed: () {
                                      if (snapshot.data) {
                                        githubService.github.users.unfollowUser(_user.login);
                                        setState(() {});
                                      } else {
                                        githubService.github.users.followUser(_user.login);
                                        setState(() {});
                                      }
                                    },
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  Divider(height: 0),
                  InkWell(
                    onTap: () => navigateToScreen(
                      context,
                      RepositoryList(
                        user: _user,
                        starredList: false,
                      ),
                    ),
                    child: _ProfileEntry(
                      name: 'Repositories',
                      count: _user.login == user.login
                          ? user.publicReposCount + user.privateReposCount
                          : _user.publicReposCount,
                    ),
                  ),
                  if (_user.login != user.login)
                    _ProfileEntry(
                      name: 'Following',
                      count: _user.followingCount,
                    ),
                  _ProfileEntry(
                    name: 'Followers',
                    count: _user.followersCount,
                  ),
                  InkWell(
                    onTap: () => navigateToScreen(
                      context,
                      RepositoryList(
                        user: _user,
                        starredList: true,
                      ),
                    ),
                    child: _ProfileEntry(
                      name: 'Starred',
                      count: _starredCount,
                    ),
                  ),
                  // todo: starred repo count?
                  // todo: organizations count?
                ],
              );
            }
          }),
    );
  }
}

class _ProfileEntry extends StatelessWidget {
  final String name;
  final int count;

  const _ProfileEntry({
    Key key,
    this.name,
    this.count,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name),
          Text('$count'),
        ],
      ),
    );
  }
}
