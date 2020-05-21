import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:github/github.dart';
import 'package:github_activity_feed/screens/user_overview.dart';
import 'package:github_activity_feed/utils/navigation_util.dart';
import 'package:github_activity_feed/widgets/feedback_on_error.dart';
import 'package:github_activity_feed/widgets/github_markdown.dart';
import 'package:github_activity_feed/widgets/view_in_browser_button.dart';
import 'package:groovin_widgets/groovin_expansion_tile.dart';
import 'package:http/http.dart' as http;
import 'package:syntax_highlighter/syntax_highlighter.dart';

/// This widget displays the contents of either a GitCommit or
/// a RepositoryCommit.
class CommitScreen extends StatefulWidget {
  CommitScreen({
    @required this.url,
  });

  final String url;

  @override
  _CommitScreenState createState() => _CommitScreenState();
}

class _CommitScreenState extends State<CommitScreen> {
  Future<RepositoryCommit> _getFullCommit() async {
    final response = await http.get(widget.url);
    return RepositoryCommit.fromJson(jsonDecode(response.body));
  }

  @override
  Widget build(BuildContext context) {
    final SyntaxHighlighterStyle style = Theme.of(context).brightness == Brightness.dark
        ? SyntaxHighlighterStyle.darkThemeStyle()
        : SyntaxHighlighterStyle.lightThemeStyle();
    return Scaffold(
      body: FutureBuilder<RepositoryCommit>(
        future: _getFullCommit(),
        builder: (BuildContext context, AsyncSnapshot<RepositoryCommit> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.data.author == null || snapshot.data.commit == null) {
              return FeedbackOnError(
                message: 'Error: No commit data found',
              );
            }
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  title: Text('Commit'),
                  pinned: true,
                  actions: [
                    ViewInBrowserButton(url: snapshot.data.htmlUrl),
                  ],
                ),
                SliverList(
                  delegate: SliverChildListDelegate([
                    Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _UserTile(user: snapshot.data.author),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                            child: GitHubMarkdown(
                              markdown: snapshot.data.commit.message,
                              useScrollable: false,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 0, 16),
                      child: Text('${snapshot.data.files.length} files changed:'),
                    ),
                  ]),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return Card(
                        child: GroovinExpansionTile(
                          title: Text(snapshot.data.files[index].name),
                          subtitle: Text(
                              '${snapshot.data.files[index].additions} additions, ${snapshot.data.files[index].deletions} deletions'),
                          children: [
                            RichText(
                              text: TextSpan(
                                style: const TextStyle(fontFamily: 'monospace', fontSize: 10.0),
                                children: <TextSpan>[
                                  DartSyntaxHighlighter(style)
                                      .format(snapshot.data.files[index].patch),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    childCount: snapshot.data.files.length,
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}

class _UserTile extends StatelessWidget {
  const _UserTile({
    Key key,
    @required this.user,
  }) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => navigateToScreen(
        context,
        UserOverview(
          user: user,
        ),
      ),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(user.avatarUrl),
      ),
      //todo: make RichText and bold the username
      title: Text(
        '${user.login} authored',
        style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
      ),
    );
  }
}

class _CommitMessage extends StatelessWidget {
  const _CommitMessage({
    Key key,
    this.message,
  }) : super(key: key);

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 4),
      child: Container(
        alignment: Alignment.centerLeft,
        child: FittedBox(
          alignment: Alignment.centerLeft,
          fit: BoxFit.scaleDown,
          child: Text(
            message,
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
      ),
    );
  }
}
