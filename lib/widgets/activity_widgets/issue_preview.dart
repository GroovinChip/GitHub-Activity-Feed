import 'package:flutter/material.dart';
import 'package:github_activity_feed/data/activity_feed_models.dart';
import 'package:github_activity_feed/utils/extensions.dart';
import 'package:github_activity_feed/widgets/user_widgets/user_avatar.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

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
              color: context.isDarkTheme
                  ? context.colorScheme.background
                  : Colors.grey, // update for light theme
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    UserAvatar(
                      avatarUrl: issue.author.avatarUrl,
                      height: 32,
                      width: 32,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        issue.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
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
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      MdiIcons.commentMultiple,
                      color: Colors.grey,
                      size: 16,
                    ),
                    SizedBox(width: 4),
                    Text(
                      '${issue.commentCount ?? 0} comments',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
