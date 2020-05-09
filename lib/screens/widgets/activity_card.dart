import 'package:flutter/material.dart';
import 'package:github/github.dart';
import 'package:github/hooks.dart';
import 'package:github_activity_feed/app/provided.dart';

class ActivityCard extends StatefulWidget {
  ActivityCard({
    Key key,
    @required this.event,
  }) : super(key: key);

  final Event event;

  @override
  _ActivityCardState createState() => _ActivityCardState();
}

class _ActivityCardState extends State<ActivityCard> with ProvidedState {
  Widget _eventWidget;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _buildActivityWidgetByType();
  }

  void _buildActivityWidgetByType() {
    switch (widget.event.type) {
      case 'CreateEvent':
        _eventWidget = _buildCreateEvent();
        break;
      case 'DeleteEvent':
        _eventWidget = _buildDeleteEvent();
        break;
      case 'ForkEvent':
        _eventWidget = _buildForkEvent();
        break;
      case 'IssueCommentEvent':
        _eventWidget = _buildIssueCommentEvent();
        break;
      case 'IssuesEvent':
        _eventWidget = _buildIssueEvent();
        break;
      case 'PushEvent':
        _eventWidget = _buildPushEvent();
        break;
      case 'WatchEvent':
        _eventWidget = _buildWatchEvent();
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: InkWell(
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        onTap: () {},
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(widget.event.actor.avatarUrl),
              ),
              title: _eventWidget,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreateEvent() {
    Widget _createEventWidget;
    switch (widget.event.payload['ref_type']) {
      case 'repository':
        _createEventWidget = _buildCreateRepo(_createEventWidget);
        break;
      case 'tag':
        _createEventWidget = _buildCreateTag(_createEventWidget);
        break;
      default:
        break;
    }
    return _createEventWidget;
  }

  Widget _buildCreateRepo(Widget _createEventWidget) {
    final _createEventWidget = RichText(
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
            text: '${widget.event.actor.login} ',
          ),
          TextSpan(
            text: 'created ${widget.event.payload['ref_type']}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(text: ' at ${widget.event.repo.name}'),
        ],
      ),
    );
    return _createEventWidget;
  }

  Widget _buildCreateTag(Widget _createEventWidget) {
    final _createEventWidget = RichText(
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
            text: '${widget.event.actor.login} ',
          ),
          TextSpan(
            text: 'created ${widget.event.payload['ref_type']} ${widget.event.payload['ref']}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(text: ' at ${widget.event.repo.name}'),
        ],
      ),
    );
    return _createEventWidget;
  }

  Widget _buildDeleteEvent() {
    final _deleteEventWidget = RichText(
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
            text: '${widget.event.actor.login}',
          ),
          TextSpan(
            text: ' deleted ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: '${widget.event.payload['ref_type']} ${widget.event.payload['ref']} at ',
          ),
          TextSpan(
            text: '${widget.event.repo.name}',
          ),
        ],
      ),
    );
    return _deleteEventWidget;
  }

  Widget _buildForkEvent() {
    final _forkEventWidget = RichText(
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
            text: '${widget.event.actor.login}',
          ),
          TextSpan(
            text: ' forked ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: '${widget.event.repo.name}',
          ),
        ],
      ),
    );
    return _forkEventWidget;
  }

  Widget _buildIssueCommentEvent() {
    IssueCommentEvent issueCommentEvent = IssueCommentEvent.fromJson(widget.event.payload);
    String issueCommentAction;
    switch (issueCommentEvent.action) {
      case 'created':
        issueCommentAction = 'commented on';
        break;
      default:
        issueCommentAction = issueCommentEvent.action;
        break;
    }
    final _issueCommentEventWidget = RichText(
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(text: '${issueCommentEvent.comment.user.login} '),
          TextSpan(
            text: '$issueCommentAction issue #${issueCommentEvent.issue.number}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(text: ' at ${widget.event.repo.name}'),
        ],
      ),
    );
    return _issueCommentEventWidget;
  }

  Widget _buildIssueEvent() {
    IssueEvent issueEvent = IssueEvent.fromJson(widget.event.payload);
    final _issueEventWidget = RichText(
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
            text: '${issueEvent.issue.user.login} ',
          ),
          TextSpan(
            text: '${issueEvent.action} issue #${issueEvent.issue.number}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(text: ' at ${widget.event.repo.name}'),
        ],
      ),
    );
    return _issueEventWidget;
  }

  Widget _buildPushEvent() {
    Map<String, dynamic> pushEvent = widget.event.payload;
    int size = pushEvent['size'];
    final _pushEventWidget = RichText(
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
            text: '${widget.event.actor.login} ',
          ),
          TextSpan(
            text: 'pushed $size ${size > 1 ? 'commits' : 'commit'} ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: 'to ${widget.event.repo.name}/${pushEvent['ref']}',
          ),
        ],
      ),
    );
    return _pushEventWidget;
  }

  Widget _buildWatchEvent() {
    final _watchEventWidget = RichText(
      text: TextSpan(children: <TextSpan>[
        TextSpan(text: widget.event.actor.login),
        TextSpan(
          text: ' starred',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        TextSpan(text: ' starred ${widget.event.repo.name}'),
      ]),
    );
    return _watchEventWidget;
  }
}
