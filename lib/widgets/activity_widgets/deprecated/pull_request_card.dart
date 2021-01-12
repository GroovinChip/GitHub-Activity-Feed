import 'package:flutter/material.dart';
import 'package:github_activity_feed/data/activity_feed_models.dart';
import 'package:github_activity_feed/utils/extensions.dart';
import 'package:github_activity_feed/widgets/activity_widgets/deprecated/pull_request_preview.dart';
import 'package:github_activity_feed/widgets/user_widgets/user_avatar.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';

@deprecated
class PullRequestCard extends StatelessWidget {
  const PullRequestCard({
    Key key,
    @required this.pullRequest,
  }) : super(key: key);

  final PullRequest pullRequest;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Material(
        elevation: 2,
        color: context.isDarkTheme ? Colors.grey[900] : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: InkWell(
          onTap: () => launch(pullRequest.url),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                /// User avatar
                leading: GestureDetector(
                  onTap: () => launch(pullRequest.author.url),
                  child: UserAvatar(
                    avatarUrl: pullRequest.author.avatarUrl,
                    height: 44,
                    width: 44,
                  ),
                ),

                /// user with action
                title: Text(
                  '${pullRequest.author.login} opened pull request',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),

                /// repository with issue number
                subtitle: Text(
                  '${pullRequest.repository.nameWithOwner} #${pullRequest.number}',
                  style: TextStyle(
                    fontSize: 14,
                    color: context.isDarkTheme ? Colors.grey : Colors.grey.shade800,
                  ),
                ),

                /// Fuzzy timestamp
                trailing: Text(timeago.format(pullRequest.createdAt, locale: 'en_short').replaceAll(' ', '')),
              ),

              /// PR preview
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: PullRequestPreview(
                  pullRequest: pullRequest,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
