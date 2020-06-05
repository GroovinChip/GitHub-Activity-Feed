import 'package:flutter/material.dart';
import 'package:github_activity_feed/data/activity_feed_models.dart';
import 'package:github_activity_feed/utils/extensions.dart';
import 'package:github_activity_feed/widgets/activity_widgets/issue_preview.dart';
import 'package:github_activity_feed/widgets/user_widgets/user_avatar.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
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
        color: context.isDarkTheme ? Colors.grey[900] : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: InkWell(
          onTap: () => launch(comment.url),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                /// User avatar
                leading: GestureDetector(
                  onTap: () => launch(comment.author.url),
                  child: UserAvatar(
                    avatarUrl: comment.author.avatarUrl,
                    height: 44,
                    width: 44,
                  ),
                ),

                /// User with action
                title: Text(
                  '${comment.author.login} commented',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),

                /// Repository with issue number
                subtitle: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      MdiIcons.alertCircleOutline,
                      color: !comment.parentIssue.closed ? Colors.green : Colors.red,
                      size: 16,
                    ),
                    SizedBox(width: 4),
                    Text(
                      '${comment.parentIssue.repository.nameWithOwner} #${comment.parentIssue.number}',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),

                /// fuzzy timestamp
                trailing: Text(
                  timeago.format(comment.createdAt, locale: 'en_short').replaceAll(' ', ''),
                ),
              ),

              /// Issue comment with issue preview
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Issue comment body
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            comment.bodyText,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.0),

                    /// Issue preview
                    IssuePreview(
                      issue: comment.parentIssue,
                      isComment: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
