import 'package:flutter/material.dart';
import 'package:github_activity_feed/data/activity_feed_models.dart';
import 'package:github_activity_feed/utils/extensions.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';

class IssueCommentCard extends StatelessWidget {
  const IssueCommentCard({
    Key key,
    @required this.comment,
  }) : super(key: key);

  final IssueComment comment;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Material(
        elevation: 2,
        color: context.isDarkTheme ? Colors.grey[800] : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: InkWell(
          onTap: () => launch(comment.url),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                /// user avatar
                leading: GestureDetector(
                  onTap: () => launch(comment.author.url),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                      comment.author.avatarUrl,
                    ),
                  ),
                ),

                /// user with action
                title: Text(
                  '${comment.author.login} commented on issue',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),

                /// repository with issue number
                subtitle: RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: '${comment.parentIssue.repository.nameWithOwner} ',
                      ),

                      /// this is here for optional styling
                      TextSpan(text: '#${comment.parentIssue.number}'),
                    ],
                  ),
                ),

                /// fuzzy timestamp
                trailing: Text(timeago.format(DateTime.parse(comment.createdAt), locale: 'en_short').replaceAll(' ', '')),
              ),

              /// issue body text preview
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Text(
                  comment.bodyText,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
