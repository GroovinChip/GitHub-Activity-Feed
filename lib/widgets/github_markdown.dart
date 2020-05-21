import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:github_activity_feed/widgets/async_markdown_scrollable.dart';
import 'package:google_fonts/google_fonts.dart';

/// Makes use of the custom AsyncMarkdown widget to parse and style markdown
class GitHubMarkdown extends StatelessWidget {
  const GitHubMarkdown({
    Key key,
    @required this.markdown,
    @required this.useScrollable,
  }) : super(key: key);

  final String markdown;
  final bool useScrollable;

  @override
  Widget build(BuildContext context) {
    return AsyncMarkdown(
      data: markdown,
      useScrollable: useScrollable,
      styleSheet: MarkdownStyleSheet(
        h1: TextStyle(
          color: Theme.of(context).colorScheme.onBackground,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        h2: TextStyle(
          color: Theme.of(context).colorScheme.onBackground,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        h3: TextStyle(
          color: Theme.of(context).colorScheme.onBackground,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        h4: TextStyle(
          color: Theme.of(context).colorScheme.onBackground,
          fontWeight: FontWeight.bold,
        ),
        p: TextStyle(
          color: Theme.of(context).colorScheme.onBackground,
        ),
        listBullet: TextStyle(
          color: Theme.of(context).colorScheme.onBackground,
        ),
        codeblockDecoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.grey[300]
              : Colors.grey[900],
        ),
        code: GoogleFonts.firaCode(
          color: Theme.of(context).colorScheme.onBackground,
        ),
        blockquoteDecoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.grey[300]
              : Colors.grey[900],
        ),
        blockquote: TextStyle(
          color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white,
        ),
      ),
    );
  }
}
