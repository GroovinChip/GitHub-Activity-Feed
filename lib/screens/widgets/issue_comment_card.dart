import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:github/github.dart';
import 'package:github_activity_feed/screens/user_overview.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeago/timeago.dart' as timeago;

/// A comment on an isse
class IssueCommentCard extends StatelessWidget {
  const IssueCommentCard({
    Key key,
    this.comment,
  }) : super(key: key);

  final IssueComment comment;

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
              leading: GestureDetector(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => UserOverview(user: comment.user)),
                ),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(comment.user.avatarUrl),
                ),
              ),
              title: Text(
                comment.user.login,
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
                      text: '${timeago.format(comment.createdAt, locale: 'en')}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              /*subtitle: Text(
                '${timeago.format(comment.createdAt, locale: 'en_short').replaceAll(' ', '')} '
                '${comment.updatedAt != null ? '• edited' : ''}',
              ),*/
            ),
            MarkdownBody(
              data: comment.body,
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
            ),
          ],
        ),
      ),
    );
  }
}
