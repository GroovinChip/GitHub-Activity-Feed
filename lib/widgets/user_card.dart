import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:github_activity_feed/data/base_user.dart';
import 'package:github_activity_feed/data/following_users.dart';
import 'package:github_activity_feed/data/viewer_following.dart';
import 'package:github_activity_feed/services/gh_gql_query_service.dart';
import 'package:github_activity_feed/utils/extensions.dart';
import 'package:github_activity_feed/widgets/report_bug_button.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class UserCard extends StatelessWidget {
  const UserCard({
    Key key,
    @required this.user,
  }) : super(key: key);

  final BaseUser user;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.isDarkTheme ? Colors.grey[900] : Colors.grey[200],
      clipBehavior: Clip.antiAlias,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: () => launch(user.url),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(user.avatarUrl ?? 'https://avatars1.githubusercontent.com/u/5868834?s=400&v=4'), // hack
                    backgroundColor: Colors.grey[200],
                  ),
                  if (user.viewerIsFollowing != null)
                    !user.viewerIsFollowing
                        ? IconButton(
                            icon: Icon(MdiIcons.accountPlusOutline),
                            onPressed: () {},
                          )
                        : Container(),
                ],
              ),
            ),
            DefaultTextStyle(
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: user.name != null
                    ? Text(
                        user.name,
                        maxLines: 1,
                      )
                    : Text(
                        '@${user.login}',
                        maxLines: 1,
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: Text(
                user.name != null ? '@${user.login}' : '',
                maxLines: 1,
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
              child: Text(
                user.bio ?? '[No bio]',
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // maybe something about contribution activity?
          ],
        ),
        /*child: Column(
          children: [
            Expanded(
              child: Ink(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  image: DecorationImage(
                    image: NetworkImage(avatarUrl),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: Icon(MdiIcons.accountPlusOutline),
                    onPressed: () {},
                  ),
                ),
              ),
            ),
            Ink(
              decoration: BoxDecoration(
                color: context.isDarkTheme ? Colors.grey[900] : Colors.grey[200],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        name != null
                            ? Text(
                              name,
                              maxLines: 1,
                              style: TextStyle(
                                //fontSize: 12,
                              ),
                            )
                            : Text(
                                '@$login',
                                maxLines: 1,
                                style: TextStyle(
                                  //fontSize: 12,
                                ),
                              ),
                        Text(
                          name != null ? '@$login' : '',
                          maxLines: 1,
                          style: TextStyle(
                            //fontSize: 10,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),*/
      ),
    );
  }
}

class UserInfoRow extends StatefulWidget {
  const UserInfoRow({
    Key key,
    @required this.id,
    @required this.avatarUrl,
    @required this.login,
    this.name,
    @required this.profileUrl,
  })  : assert(id != null),
        assert(avatarUrl != null),
        assert(login != null),
        super(key: key);

  final String id;
  final String avatarUrl;
  final String login;
  final String name;
  final String profileUrl;

  @override
  _UserInfoRowState createState() => _UserInfoRowState();
}

class _UserInfoRowState extends State<UserInfoRow> {
  @override
  Widget build(BuildContext context) {
    final ghGraphQLService = Provider.of<GhGraphQLService>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(widget.avatarUrl),
          ),
          SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                widget.name ?? widget.login,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                widget.login,
              ),
            ],
          ),
          Spacer(),
          FutureBuilder<dynamic>(
            future: ghGraphQLService.isViewerFollowingUser(widget.login),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasError) {
                return ReportBugButton();
              } else if (!snapshot.hasData) {
                return SizedBox(
                  height: 45,
                  width: 45,
                  child: Material(
                    color: Theme.of(context).accentColor,
                    shape: const CircleBorder(),
                    child: Center(
                      child: Icon(
                        Icons.person_outline,
                        size: 18,
                        color: context.colorScheme.onSecondary,
                      ),
                    ),
                  ),
                );
              } else {
                ViewerFollowing viewerFollowing = ViewerFollowing.fromJson(snapshot.data['user']);
                return SizedBox(
                  height: 45,
                  width: 45,
                  child: Material(
                    color: Theme.of(context).accentColor,
                    shape: const CircleBorder(),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () {
                        if (viewerFollowing.viewerIsFollowing == true) {
                          ghGraphQLService.unfollowUser(widget.id);
                          SchedulerBinding.instance.addPostFrameCallback((_) => setState(() {}));
                        } else {
                          ghGraphQLService.followUser(widget.id);
                          SchedulerBinding.instance.addPostFrameCallback((_) => setState(() {}));
                        }
                      },
                      child: Center(
                        child: Icon(
                          viewerFollowing.viewerIsFollowing
                              ? MdiIcons.accountMinusOutline
                              : MdiIcons.accountPlusOutline,
                          size: 18,
                          color: context.colorScheme.onSecondary,
                        ),
                      ),
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
