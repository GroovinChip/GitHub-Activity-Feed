import 'package:flutter/material.dart';
import 'package:github/github.dart';
import 'package:github_activity_feed/screens/user_overview.dart';
import 'package:github_activity_feed/utils/navigation_util.dart';

class UserListTile extends StatelessWidget {
  const UserListTile({
    Key key,
    this.login,
    this.avatarUrl,
  }) : super(key: key);

  final String login;
  final String avatarUrl;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ListTile(
        /*onTap: () => navigateToScreen(
          context,
          UserOverview(
            user: user,
          ),
        ),*/
        leading: CircleAvatar(
          backgroundImage: NetworkImage(avatarUrl),
        ),
        title: Text(
          login,
          style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
        ),
      ),
    );
  }
}
