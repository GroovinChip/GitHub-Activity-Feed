import 'package:flutter/material.dart';
import 'package:github/github.dart';
import 'package:github/hooks.dart';
import 'package:github_activity_feed/app/provided.dart';
import 'package:github_activity_feed/utils/color_from_string.dart';
import 'package:github_activity_feed/widgets/issue_comment_card.dart';
import 'package:github_activity_feed/widgets/pr_header_bar.dart';
import 'package:github_activity_feed/widgets/pull_request_card.dart';
import 'package:github_activity_feed/widgets/view_in_browser_button.dart';
import 'package:groovin_widgets/groovin_widgets.dart';

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
          List<Widget> labelWidgets = [];
          for (int i = 0; i < pullRequest.labels.length; i++) {
            Color backgroundColor = HexColor(pullRequest.labels[i].color);
            Color foregroundColor =
                backgroundColor.computeLuminance() > 0.5 ? Colors.black : Colors.white;
            labelWidgets.add(
              Container(
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(4),
                ),
                padding: EdgeInsets.fromLTRB(4, 2, 4, 2),
                child: Text(
                  pullRequest.labels[i].name,
                  style: TextStyle(color: foregroundColor),
                ),
              ),
            );
            if (i != pullRequest.labels.length) {
              labelWidgets.add(
                SizedBox(width: 4),
              );
            }
          }
          return CustomScrollView(
            slivers: [
              /// PR header
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
                  ],
                ),
                actions: [
                  ViewInBrowserButton(url: pullRequest.htmlUrl),
                ],
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
                  PullRequestCard(pullRequest: pullRequest),

                  /// PR labels
                  labelWidgets.isNotEmpty
                      ? Card(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8, bottom: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ...labelWidgets,
                              ],
                            ),
                          ),
                        )
                      : Container(),
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
                          return IssueCommentCard(
                            comment: snapshot.data[index],
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
