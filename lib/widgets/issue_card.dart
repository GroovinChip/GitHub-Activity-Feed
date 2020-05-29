import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;


class IssueCard extends StatelessWidget {
  const IssueCard({
    Key key,
    @required this.issue,
  }) : super(key: key);

  final dynamic issue;

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
              onTap: () {},
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                  issue['author']['avatarUrl'],
                ),
              ),
            ),

            /// user with action
            title: Text(
              '${issue['author']['login']} opened issue',
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
                    text: '${issue['repository']['nameWithOwner']} ',
                  ),

                  /// this is here for optional styling
                  TextSpan(text: '#${issue['number']}'),
                ],
              ),
            ),

            /// fuzzy timestamp
            trailing: Text(timeago
                .format(DateTime.parse(issue['createdAt']), locale: 'en_short')
                .replaceAll(' ', '')),
          ),

          /// issue body text preview
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              issue['bodyText'] ?? 'No description',
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
