import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:github/github.dart';
import 'package:github/hooks.dart';
import 'package:github_activity_feed/app/provided.dart';
import 'package:github_activity_feed/services/extensions.dart';
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
  final _headerKey = GlobalKey<_IssueHeaderBarState>();
  Size _headerSize;
  IssueEvent _issueEvent;
  IssueCommentEvent _issueCommentEvent;
  Issue _issue;
  Repository _repo;
  RepositorySlug _repositorySlug;
  List<IssueComment> _issueComments = [];
  /*var _event;*/

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_getHeaderSize);

    /// might need to call the issue Url/issue comment url to make a model with complete data
    if (widget.event.type == 'IssuesEvent') {
      _issueEvent = IssueEvent.fromJson(widget.event.payload);
      _issue = _issueEvent.issue;
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
    setState(() {
      for (Map i in data) {
        _issueComments.add(IssueComment.fromJson(i));
      }
    });
  }

  void _getHeaderSize(_) {
    final RenderBox headerBox = _headerKey.currentContext.findRenderObject();
    _headerSize = headerBox.size;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text(
              '${widget.event.repo.name}',
            ),
            bottom: PreferredSize(
              preferredSize: _headerSize,
              child: IssueHeaderBar(
                key: _headerKey,
                issue: _issue,
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
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
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
                              subtitle: Text(
                                '${timeago.format(_issue.createdAt, locale: 'en_short').replaceAll(' ', '')} '
                                '${_issue.updatedAt != null ? '• edited' : ''}',
                              ),
                            ),
                            Text(_issue.body),
                          ],
                        ),
                      ),
                    ),
                  ),
                for (IssueComment comment in _issueComments) Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                  child: IssueEntry(comment: comment),
                )
              ],
            ),
          ),
        ],
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
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: '#${widget.issue.number}',
                  style: TextStyle(
                    fontSize: 18,
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
        padding: const EdgeInsets.all(8.0),
        child: Column(
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
              subtitle: Text(
                '${timeago.format(comment.createdAt, locale: 'en_short').replaceAll(' ', '')} '
                '${comment.updatedAt != null ? '• edited' : ''}',
              ),
            ),
            Text(comment.body),
          ],
        ),
      ),
    );
  }
}
