import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:timeago/timeago.dart' as timeago;

class UserCard extends StatelessWidget {
  const UserCard({
    Key key,
    @required this.user,
  }) : super(key: key);

  final dynamic user;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: UserRow(
        avatarUrl: user['avatarUrl'],
        login: user['login'],
        name: user['name'],
        viewerIsFollowing: user['viewerIsFollowing'],
        profileUrl: user['url'],
      ),
    );
  }
}

class UserRow extends StatefulWidget {
  const UserRow({
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
  _UserRowState createState() => _UserRowState();
}

class _UserRowState extends State<UserRow> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
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
                widget.login,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(widget.name ?? widget.login),
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
