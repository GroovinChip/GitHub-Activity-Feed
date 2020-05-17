import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:github/github.dart';
import 'package:github/hooks.dart';
import 'package:github_activity_feed/app/provided.dart';
import 'package:github_activity_feed/screens/widgets/async_markdown.dart';
import 'package:github_activity_feed/screens/widgets/custom_stream_builder.dart';
import 'package:github_activity_feed/services/extensions.dart';
import 'package:github_activity_feed/utils/stream_helpers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:http/http.dart' as http;

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
  Repository _repo;
  RepositorySlug _repositorySlug;
  List<IssueComment> _issueComments = [];
  /*var _event;*/

  @override
  void initState() {
    super.initState();
    //WidgetsBinding.instance.addPostFrameCallback(_getHeaderSize);
    _repositorySlug = RepositorySlug.full(widget.event.repo.name);
    if (widget.event.type == 'IssuesEvent') {
      _issueEvent = IssueEvent.fromJson(widget.event.payload);
      _issue = _issueEvent.issue;
      updateBehaviorSubjectAsync(
        _issueSubject,
        () => githubService.github.issues.get(_repositorySlug, _issue.number),
      );
      _repo = _issueEvent.repository;
      _getIssueComments();
    } else if (widget.event.type == 'IssueCommentEvent') {
      _issueCommentEvent = IssueCommentEvent.fromJson(widget.event.payload);
      _issue = _issueCommentEvent.issue;
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
          return Center(
            child: Text('$error'),
          );
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
                    if (_issue.body.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(_issue.user.avatarUrl),
                                  ),
                                  title: Text(
                                    _issue.user.login,
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
                                          text:
                                              '${timeago.format(_issue.createdAt, locale: 'en_short')}',
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
                                MarkdownBody(
                                  data: _issue.body,
                                  styleSheet: MarkdownStyleSheet(
                                    codeblockDecoration: BoxDecoration(
                                      color: Theme.of(context).brightness == Brightness.light
                                          ? Colors.grey[300]
                                          : Theme.of(context).canvasColor,
                                    ),
                                    code: GoogleFonts.firaCode(
                                      backgroundColor: Theme.of(context).brightness == Brightness.light
                                          ? Colors.grey[300]
                                          : Theme.of(context).canvasColor,
                                      color: Theme.of(context).brightness == Brightness.light
                                          ? Colors.black
                                          : Colors.white,
                                    ),
                                  ),
                                ),
                                /*Text(_issue.body.trim()),*/
                              ],
                            ),
                          ),
                        ),
                      ),
                    for (IssueComment comment in _issueComments)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                        child: IssueEntry(comment: comment),
                      )
                  ],
                ),
              ),
              if (_issueComments.isEmpty && _issue.body.isEmpty)
                SliverList(
                  delegate: SliverChildListDelegate([
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(_issue.user.avatarUrl),
                                ),
                                title: Text(
                                  _issue.user.login,
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
                                        text: '${timeago.format(_issue.createdAt, locale: 'en')}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                /*subtitle: Text(
                                  'commented ${timeago.format(_issue.createdAt, locale: 'en_short').replaceAll(' ', '').replaceAll('~', '')} ago'
                                ),*/
                              ),
                              Text('No description provided'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ]),
                ),
              if (_issueComments.isEmpty && _issue.body.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Text('No comments'),
                  ),
                ),
            ],
          );
        }
      ),
    );
  }
}

class IssueHeaderBar extends StatefulWidget {
  final Issue issue;

  const IssueHeaderBar({
    Key key,
    this.issue,
  }) : super(key: key);

  @override
  _IssueHeaderBarState createState() => _IssueHeaderBarState();
}

class _IssueHeaderBarState extends State<IssueHeaderBar> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12, bottom: 8, right: 12),
          child: RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: '${widget.issue.title} ',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: '#${widget.issue.number}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 12, bottom: 12, right: 12),
          child: Material(
            color: widget.issue.state == 'open' ? Colors.green : Colors.red,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(6, 2, 6, 2),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.info_outline),
                  SizedBox(width: 2),
                  Text(widget.issue.state.capitalize()),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class IssueEntry extends StatelessWidget {
  final IssueComment comment;

  const IssueEntry({
    Key key,
    this.comment,
  }) : super(key: key);

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
                backgroundImage: NetworkImage(comment.user.avatarUrl),
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
