import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:github_activity_feed/data/base_user.dart';
import 'package:github_activity_feed/utils/extensions.dart';
import 'package:github_activity_feed/widgets/user_widgets/user_avatar.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

/// A tile that represents a User, with less detail than [UserCard]
class UserTile extends StatelessWidget {
  final BaseUser user;

  const UserTile({
    Key key,
    this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RippleCard(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      onTap: () => url_launcher.launch(user.url),
      child: UserInfoRow(
        user: user,
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
        color: context.isDarkTheme ? Colors.grey[900] : Colors.white,
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

class UserInfoRow extends StatelessWidget {
  const UserInfoRow({
    Key key,
    @required this.user,
  });

  final BaseUser user;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          UserAvatar(
            avatarUrl: user.avatarUrl,
            height: 44,
            width: 44,
          ),
          SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                user.name ?? user.login,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(user.login),
            ],
          ),
        ],
      ),
    );
  }
}
