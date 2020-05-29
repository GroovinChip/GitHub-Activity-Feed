import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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
    @required this.avatarUrl,
    @required this.id,
    @required this.login,
    @required this.name,
    @required this.url,
  }) : super(key: key);

  final String avatarUrl;
  final String id;
  final String login;
  final String name;
  final String url;

  @override
  Widget build(BuildContext context) {
    return RippleCard(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      onTap: () => launch(url),
      child: UserInfoRow(
        id: id,
        avatarUrl: avatarUrl,
        login: login,
        name: name,
        profileUrl: url,
      ),
    );
  }
}

class RippleCard extends StatelessWidget {
  const RippleCard({
    Key key,
    this.shape,
    this.onTap,
    this.child,
  }) : super(key: key);

  final ShapeBorder shape;
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Material(
        color: context.isDarkTheme ? Colors.grey[800] : Colors.white,
        shape: shape,
        elevation: 2.0,
        child: InkWell(
          customBorder: shape,
          onTap: onTap,
          child: child,
        ),
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
                          viewerFollowing.viewerIsFollowing ? MdiIcons.accountMinusOutline : MdiIcons.accountPlusOutline,
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
