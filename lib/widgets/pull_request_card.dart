import 'package:flutter/material.dart';
import 'package:github/github.dart';
import 'package:github_activity_feed/screens/user_overview.dart';
import 'package:github_activity_feed/utils/navigation_util.dart';
import 'package:github_activity_feed/widgets/github_markdown.dart';

class PullRequestCard extends StatelessWidget {
  const PullRequestCard({
    Key key,
    @required this.pullRequest,
  }) : super(key: key);

  final PullRequest pullRequest;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _UserTile(user: pullRequest.user),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 12),
            child: GitHubMarkdown(
              markdown: pullRequest.body,
              useScrollable: false,
            ),
          ),
        ],
      ),
    );
  }
}

class _UserTile extends StatelessWidget {
  const _UserTile({
    Key key,
    @required this.user,
  }) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => navigateToScreen(context, UserOverview(user: user)),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(user.avatarUrl),
      ),
      title: Text(
        user.login,
        style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
      ),
    );
  }
}
