import 'package:flutter/material.dart';
import 'package:github_activity_feed/screens/user_overview.dart';
import 'package:timeago/timeago.dart' as timeago;

class IssueCommentCard extends StatelessWidget {
  const IssueCommentCard({
    Key key,
    @required this.comment,
  }) : super(key: key);

  final dynamic comment;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            /// user avatar
            leading: GestureDetector(
              onTap: () => UserOverview(
                login: comment['author']['login'],
                isViewer: comment['author']['isViewer'],
              ),
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                  comment['author']['avatarUrl'],
                ),
              ),
            ),

            /// user with action
            title: Text(
              '${comment['author']['login']} commented',
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
                    text: '${comment['issue']['repository']['nameWithOwner']} ',
                  ),

                  /// this is here for optional styling
                  TextSpan(text: '#${comment['issue']['number']}'),
                ],
              ),
            ),

            /// fuzzy timestamp
            trailing: Text(timeago
                .format(DateTime.parse(comment['createdAt']), locale: 'en_short')
                .replaceAll(' ', '')),
          ),

          /// issue body text preview
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              comment['bodyText'],
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 14),
            ),
          )
        ],
      ),
    );
  }
}
