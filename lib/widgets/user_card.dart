import 'package:flutter/material.dart';
import 'package:github_activity_feed/utils/extensions.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class UserCard extends StatelessWidget {
  const UserCard({
    Key key,
    @required this.user,
  }) : super(key: key);

  final dynamic user;

  @override
  Widget build(BuildContext context) {
    return RippleCard(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      onTap: () => launch(user['url']),
      child: UserInfoRow(
        avatarUrl: user['avatarUrl'],
        login: user['login'],
        name: user['name'],
        viewerIsFollowing: user['viewerIsFollowing'],
        profileUrl: user['url'],
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
    @required this.avatarUrl,
    @required this.login,
    this.name,
    @required this.viewerIsFollowing,
    @required this.profileUrl,
  })  : assert(avatarUrl != null),
        assert(login != null),
        assert(viewerIsFollowing != null),
        super(key: key);

  final String avatarUrl;
  final String login;
  final String name;
  final bool viewerIsFollowing;
  final String profileUrl;

  @override
  _UserInfoRowState createState() => _UserInfoRowState();
}

class _UserInfoRowState extends State<UserInfoRow> {
  @override
  Widget build(BuildContext context) {
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
          SizedBox(
            height: 45,
            width: 45,
            child: Material(
              color: Theme.of(context).accentColor,
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: () {},
                child: Center(
                  child: Icon(
                    widget.viewerIsFollowing
                        ? MdiIcons.accountMinusOutline
                        : MdiIcons.accountPlusOutline,
                    size: 18,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
