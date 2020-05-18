import 'package:flutter/material.dart';
import 'package:github/github.dart';
import 'package:github_activity_feed/app/provided.dart';
import 'package:github_activity_feed/services/extensions.dart';
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
  bool _isFollowingUser = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _checkIsFollowingUser();
  }

  void _checkIsFollowingUser() {
    if (widget.currentUser.login != user.login) {
      githubService.github.users.isFollowingUser(widget.currentUser.login).then((bool isFollowing) {
        setState(() {
          _isFollowingUser = isFollowing;
        });
      });
    }
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
            return Column(
              children: [
                if (snapshot.data.bio != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: ListTile(
                        title: Text(snapshot.data.bio),
                      ),
                    ),
                  ),
                if (!snapshot.data.company.isNullOrEmpty)
                  ListTile(
                    leading: Icon(MdiIcons.officeBuilding),
                    title: Text(snapshot.data.company),
                  ),
                if (snapshot.data.location.isNotEmpty)
                  ListTile(
                    leading: Icon(MdiIcons.mapMarkerOutline),
                    title: Text(snapshot.data.location),
                  ),
                if (snapshot.data.blog.isNotEmpty)
                  ListTile(
                    leading: Icon(MdiIcons.link),
                    title: Text(snapshot.data.blog),
                  ),
                if (snapshot.data.createdAt != null)
                  ListTile(
                    leading: Icon(Icons.access_time),
                    title: Text(snapshot.data.createdAt.asMonthDayYear),
                  ),
                if (widget.currentUser.login != user.login)
                  Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: RaisedButton.icon(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            icon: Icon(!_isFollowingUser ? MdiIcons.accountPlusOutline : MdiIcons.accountMinusOutline),
                            label: Text(!_isFollowingUser ? 'Follow' : 'Unfollow'),
                            onPressed: () {
                              if (_isFollowingUser) {
                                githubService.github.users.unfollowUser(snapshot.data.login);
                                setState(() => _isFollowingUser = false);
                              } else {
                                githubService.github.users.followUser(snapshot.data.login);
                                setState(() => _isFollowingUser = true);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                Divider(height: 0),
                _ProfileEntry(
                  name: 'Repositories',
                  count: snapshot.data.login == user.login
                      ? user.publicReposCount + user.privateReposCount
                      : snapshot.data.publicReposCount,
                ),
                if (snapshot.data.login != user.login)
                  _ProfileEntry(
                    name: 'Following',
                    count: snapshot.data.followingCount,
                  ),
                _ProfileEntry(
                  name: 'Followers',
                  count: snapshot.data.followersCount,
                ),
                // todo: starred repo count?
                // todo: organizations count?
              ],
            );
          }
        }
      ),
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
