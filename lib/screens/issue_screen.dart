import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:github/github.dart';
import 'package:github/hooks.dart';
import 'package:github_activity_feed/app/provided.dart';
import 'package:github_activity_feed/utils/stream_helpers.dart';
import 'package:github_activity_feed/widgets/custom_stream_builder.dart';
import 'package:github_activity_feed/widgets/feedback_on_error.dart';
import 'package:github_activity_feed/widgets/issue_card.dart';
import 'package:github_activity_feed/widgets/issue_comment_card.dart';
import 'package:github_activity_feed/widgets/issue_header_bar.dart';
import 'package:github_activity_feed/widgets/view_in_browser_button.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

class IssueScreen extends StatefulWidget {
  IssueScreen({
    Key key,
    @required this.event,
  }) : super(key: key);

  final Event event;

  @override
  _IssueScreenState createState() => _IssueScreenState();
}

class _IssueScreenState extends State<IssueScreen> with ProvidedState {
  final _headerKey = GlobalKey();
  double _headerSize;
  IssueEvent _issueEvent;
  IssueCommentEvent _issueCommentEvent;
  Issue _issue;
  final _issueSubject = BehaviorSubject<Issue>();
  //final _issueEvents = BehaviorSubject<List<IssueEvent>>();
  Repository _repo;
  RepositorySlug _repositorySlug;
  List<IssueComment> _issueComments = [];
  /*var _event;*/

  @override
  void initState() {
    super.initState();
    _repositorySlug = RepositorySlug.full(widget.event.repo.name);
    if (widget.event.type == 'IssuesEvent') {
      _issueEvent = IssueEvent.fromJson(widget.event.payload);
      _issue = _issueEvent.issue;
      updateBehaviorSubjectAsync(
        _issueSubject,
        () => githubService.github.issues.get(_repositorySlug, _issue.number),
      );
      /*updateBehaviorSubjectAsync(
        _issueEvents,
        () => githubService.github.activity
            .listIssueEvents(widget.event.actor.login, _repositorySlug, _issue.number)
            .toList(),
      );*/
      _repo = _issueEvent.repository;
      _getIssueComments();
    } else if (widget.event.type == 'IssueCommentEvent') {
      _issueCommentEvent = IssueCommentEvent.fromJson(widget.event.payload);
      _issue = _issueCommentEvent.issue;
      updateBehaviorSubjectAsync(
        _issueSubject,
        () => githubService.github.issues.get(_repositorySlug, _issue.number),
      );
      _getIssueComments();
    }
  }

  void _getIssueComments() async {
    final response = await http.get(_issue.commentsUrl);
    final data = jsonDecode(response.body);
    //print(data);
    setState(() {
      for (Map i in data) {
        _issueComments.add(IssueComment.fromJson(i));
      }
    });
  }

  void _getHeaderSize(_) {
    final RenderBox headerBox = _headerKey.currentContext.findRenderObject();
    setState(() => _headerSize = headerBox.getMaxIntrinsicHeight(headerBox.size.width));
  }

  @override
  void dispose() {
    _issueSubject.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SubjectStreamBuilder(
          subject: _issueSubject,
          errorBuilder: (BuildContext context, error) {
            return FeedbackOnError(message: 'Error');
          },
          builder: (BuildContext context, Issue issue) {
            WidgetsBinding.instance.addPostFrameCallback(_getHeaderSize);
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  snap: true,
                  floating: true,
                  expandedHeight: _headerSize ?? 100.0,
                  title: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '${widget.event.repo.name}',
                    ),
                  ),
                  actions: [
                    ViewInBrowserButton(url: issue.htmlUrl),
                  ],
                  bottom: PreferredSize(
                    preferredSize: Size.fromHeight(_headerSize ?? 100.0),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: IssueHeaderBar(
                        key: _headerKey,
                        issue: issue,
                      ),
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      if (issue.body.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: IssueCard(
                            issue: issue,
                            hasDescription: true,
                          ),
                        ),
                      for (IssueComment comment in _issueComments)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                          child: IssueCommentCard(comment: comment),
                        )
                    ],
                  ),
                ),
                if (_issueComments.isEmpty && _issue.body.isEmpty)
                  SliverList(
                    delegate: SliverChildListDelegate([
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: IssueCard(issue: issue, hasDescription: false),
                      ),
                    ]),
                  ),
                if (_issueComments.isEmpty && issue.body.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Text('No comments'),
                    ),
                  ),
              ],
            );
          }),
    );
  }
}
