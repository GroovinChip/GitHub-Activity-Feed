import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:github/github.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeago/timeago.dart' as timeago;

/// The body of an issue
class IssueCard extends StatelessWidget {
  const IssueCard({
    Key key,
    @required this.issue,
    @required this.hasDescription,
  }) : super(key: key);

  final Issue issue;
  final bool hasDescription;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                backgroundImage: NetworkImage(issue.user.avatarUrl),
              ),
              title: Text(
                issue.user.login,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.caption.copyWith(
                        fontSize: 12,
                      ),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'commented ',
                    ),
                    TextSpan(
                      text: '${timeago.format(issue.createdAt, locale: 'en_short')}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: ' ago',
                    ),
                  ],
                ),
              ),
            ),
            hasDescription ? MarkdownBody(
              data: issue.body,
              styleSheet: MarkdownStyleSheet(
                codeblockDecoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.grey[300]
                      : Theme.of(context).canvasColor,
                ),
                code: GoogleFonts.firaCode(
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.black
                      : Colors.white,
                ),
                blockquoteDecoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.grey[300]
                      : Theme.of(context).canvasColor,
                ),
                blockquote: TextStyle(
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.black
                      : Colors.white,
                ),
              ),
            ) : Text('No description provided'),
            /*Text(_issue.body.trim()),*/
          ],
        ),
      ),
    );
  }
}
