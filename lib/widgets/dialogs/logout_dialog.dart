import 'package:flutter/material.dart';
import 'package:github_activity_feed/services/github_service.dart';
import 'package:github_activity_feed/utils/extensions.dart';

class LogOutDialog extends StatelessWidget {
  const LogOutDialog({
    Key key,
    @required this.githubService,
  }) : super(key: key);

  final GitHubService githubService;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Text(
        'Would you like to log out?',
        style: TextStyle(
          color: context.colorScheme.onBackground,
        ),
      ),
      actions: [
        FlatButton(
          textColor: context.colorScheme.onBackground,
          child: Text('Cancel'),
          onPressed: () => Navigator.pop(context),
        ),
        FlatButton(
          child: Text('Yes'),
          onPressed: () => githubService.logOut(),
        ),
      ],
    );
  }
}
