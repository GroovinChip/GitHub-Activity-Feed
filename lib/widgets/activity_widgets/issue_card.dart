import 'package:flutter/material.dart';
import 'package:github_activity_feed/data/activity_feed_models.dart';
import 'package:github_activity_feed/utils/extensions.dart';
import 'package:github_activity_feed/widgets/user_widgets/user_avatar.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';

class IssueCard extends StatelessWidget {
  const IssueCard({
    Key key,
    @required this.issue,
  }) : super(key: key);

  final Issue issue;

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
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          onTap: () => launch(issue.url),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                /// User avatar
                leading: GestureDetector(
                  onTap: () => launch(issue.author.url),
                  child: UserAvatar(
                    avatarUrl: issue.author.avatarUrl,
                    height: 44,
                    width: 44,
                  ),
                ),

                /// User with action
                title: Text(
                  '${issue.author.login} opened issue',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),

                /// Repository with issue number
                subtitle: RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: '${issue.repository.nameWithOwner} ',
                      ),

                      /// this is here for optional styling
                      TextSpan(text: '#${issue.number}'),
                    ],
                  ),
                ),

                /// Fuzzy timestamp
                trailing: Text(timeago.format(issue.createdAt, locale: 'en_short').replaceAll(' ', '')),
              ),

              /// Issue preview
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: IssuePreview(issue: issue),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class IssuePreview extends StatelessWidget {
  const IssuePreview({
    Key key,
    @required this.issue,
  }) : super(key: key);

  final Issue issue;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              border: Border.all(
                color: context.isDarkTheme ? Colors.grey : Colors.black,
              ),
              borderRadius: BorderRadius.circular(8.0),
              color: context.isDarkTheme ? context.colorScheme.background : Colors.grey, // update for light theme
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  issue.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  issue.bodyText ?? 'No description',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  '${issue.commentCount} comments',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
