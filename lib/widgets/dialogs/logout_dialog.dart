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
      title: Text(
        'Log Out',
        style: TextStyle(
          color: context.colorScheme.onBackground,
        ),
      ),
      actions: [
        TextButton(
          child: Text('Cancel'),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton(
          child: Text('Log Out'),
          onPressed: () => githubService.logOut(),
        ),
      ],
    );
  }
}
