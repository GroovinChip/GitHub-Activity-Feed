import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:github/github.dart';
import 'package:github/hooks.dart';
import 'package:github_activity_feed/app/provided.dart';
import 'package:github_activity_feed/screens/commit_list_screen.dart';
import 'package:github_activity_feed/screens/user_overview.dart';
import 'package:github_activity_feed/utils/color_from_string.dart';
import 'package:github_activity_feed/utils/prettyJson.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:groovin_widgets/groovin_widgets.dart';
import 'package:http/http.dart' as http;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class PullRequestScreen extends StatefulWidget {
  PullRequestScreen({
    Key key,
    this.event,
    this.pullRequestEvent,
  }) : super(key: key);

  final Event event;
  final PullRequestEvent pullRequestEvent;

  @override
  _PullRequestScreenState createState() => _PullRequestScreenState();
}

class _PullRequestScreenState extends State<PullRequestScreen> with ProvidedState {
  final _headerKey = GlobalKey();
  double headerSize;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_getHeaderSize);
  }

  void _getHeaderSize(_) {
    final RenderBox headerBox = _headerKey.currentContext.findRenderObject();
    setState(() => headerSize = headerBox.getMaxIntrinsicHeight(headerBox.size.width));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<PullRequest>(
        initialData: widget.pullRequestEvent.pullRequest,
        future: githubService.github.pullRequests.get(
          RepositorySlug.full(widget.event.repo.name),
          widget.pullRequestEvent.pullRequest.number,
        ),
        builder: (BuildContext context, AsyncSnapshot<PullRequest> snapshot) {
          PullRequest pullRequest = snapshot.data;
          List<Widget> labels = [];
          for (int i = 0; i > pullRequest.labels.length; i++) {
            IssueLabel label = pullRequest.labels[i];
            labels.add(
              Container(
                color: hexToColor(label.color),
                child: Text(label.name),
              ),
            );
          }
          return CustomScrollView(
            slivers: [
              /// header
              SliverAppBar(
                automaticallyImplyLeading: false,
                snap: true,
                floating: true,
                expandedHeight: headerSize ?? 0.0,
                title: Row(
                  children: [
                    AvatarBackButton(
                      avatar: pullRequest.user.avatarUrl,
                      onPressed: () => Navigator.pop(context),
                    ),
                    SizedBox(width: 16),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '${pullRequest.head.repo.fullName}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(headerSize ?? 0.0),
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: PullRequestHeaderBar(
                      key: _headerKey,
                      pullRequest: pullRequest,
                      action: widget.pullRequestEvent.action,
                      commitsUrl: widget.event.payload['pull_request']['commits_url'],
                    ),
                  ),
                ),
              ),

              /// PR body
              SliverList(
                delegate: SliverChildListDelegate([
                  Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _UserTile(user: pullRequest.user),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                          child: MarkdownBody(
                            data: pullRequest.body,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      ...labels,
                    ],
                  ),
                ]),
              ),

              /// Comments on the PR
              FutureBuilder<List<IssueComment>>(
                //initialData: [],
                future: githubService.github.issues
                    .listCommentsByIssue(
                      RepositorySlug.full(widget.event.repo.name),
                      pullRequest.number,
                    )
                    .toList(),
                builder: (BuildContext context, AsyncSnapshot<List<IssueComment>> snapshot) {
                  if (!snapshot.hasData) {
                    return SliverFillRemaining(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else if (snapshot.data.length > 0) {
                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          return Card(
                            child: Column(
                              children: [
                                _UserTile(user: snapshot.data[index].user),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                                  child: MarkdownBody(
                                    data: snapshot.data[index].body,
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
                                ),
                              ],
                            ),
                          );
                        },
                        childCount: snapshot.data.length,
                      ),
                    );
                  } else {
                    return SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Text('No comments'),
                      ),
                    );
                  }
                },
              ),
            ],
          );
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
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => UserOverview(
            user: user,
          ),
        ),
      ),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(user.avatarUrl),
      ),
      title: Text(
        user.login,
        style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
      ),
    );
  }
}

class PullRequestHeaderBar extends StatefulWidget {
  const PullRequestHeaderBar({
    Key key,
    this.pullRequest,
    this.action,
    this.commitsUrl,
  }) : super(key: key);

  final PullRequest pullRequest;
  final String action;
  final String commitsUrl;

  @override
  _PullRequestHeaderBarState createState() => _PullRequestHeaderBarState();
}

class _PullRequestHeaderBarState extends State<PullRequestHeaderBar> with ProvidedState {
  List<dynamic> _prCommits = [];

  Future<List<dynamic>> _getCommitsFromNetwork() async {
    final response = await http.get(widget.commitsUrl);
    return jsonDecode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 8),
          child: RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: '${widget.pullRequest.title}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
                TextSpan(text: ' #${widget.pullRequest.number}'),
              ],
            ),
          ),
        ),
        Row(
          children: [
            SizedBox(width: 16),
            Material(
              color: Colors.blue[800],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(6, 2, 6, 2),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(widget.pullRequest.head.ref),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 4, right: 4),
              child: Icon(
                Icons.arrow_forward,
                size: 20,
                color: Colors.grey,
              ),
            ),
            Material(
              color: Colors.blue[800],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(6, 2, 6, 2),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [Text(widget.pullRequest.base.ref)],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Row(
          children: [
            SizedBox(width: 16),
            Material(
              color: Colors.deepPurple[700],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(6, 2, 6, 2),
                child: Row(
                  children: [
                    Icon(MdiIcons.sourcePull, size: 20),
                    SizedBox(width: 4),
                    Text(widget.action),
                  ],
                ),
              ),
            ),
          ],
        ),
        ListTile(
          leading: Transform.rotate(
            angle: 4.7,
            child: Icon(MdiIcons.sourceCommit),
          ),
          title: FutureBuilder<List<dynamic>>(
            future: _getCommitsFromNetwork(),
            builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
              if (!snapshot.hasData) {
                return Text('...');
              } else {
                _prCommits = snapshot.data;
                return Text(
                  snapshot.data.length > 1
                      ? '${_prCommits.length} commits'
                      : '${_prCommits.length} commit',
                );
              }
            },
          ),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CommitListScreen(
                repoName: widget.pullRequest.head.repo.fullName,
                committedBy: widget.pullRequest.user,
                commits: _prCommits,
                fromEventType: 'PullRequest',
              ),
            ),
          ),
        ),
      ],
    );
  }
}
