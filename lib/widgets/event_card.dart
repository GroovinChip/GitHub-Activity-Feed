import 'package:flutter/material.dart';
import 'package:github/github.dart';
import 'package:github/hooks.dart';
import 'package:github_activity_feed/app/provided.dart';
import 'package:github_activity_feed/screens/user_overview.dart';
import 'package:github_activity_feed/utils/navigation_util.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;

class EventCard extends StatefulWidget {
  EventCard({
    Key key,
    @required this.event,
  }) : super(key: key);

  final dynamic event;

  @override
  _EventCardState createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> with ProvidedState {
  Widget _eventWidget;

  @override
  void initState() {
    super.initState();
    _buildActivityWidgetByType();
  }

  void _buildActivityWidgetByType() {
    switch (widget.event['__typename']) {
      case 'Issue':
        //_buildIssueEvent();
        break;
      case 'IssueComment':
        _buildIssueCommentEvent();
        break;
      case 'PullRequest':
        //_buildPullRequestEvent();
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
      child: _eventWidget,
    );
  }

  Widget _buildIssueCommentEvent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: GestureDetector(
            onTap: () => navigateToScreen(
              context,
              UserOverview(
                user: widget.event['author']['login'],
              ),
            ),
            child: CircleAvatar(
              backgroundImage: NetworkImage(widget.event['author']['avatarUrl']),
            ),
          ),
          title: Text(widget.event['author']['login'])
        ),
      ],
    );
  }

  Widget _buildIssueEvent() {
    IssueEvent issueEvent = IssueEvent.fromJson(widget.event.payload);
    return ListTile(
      leading: GestureDetector(
        onTap: () => navigateToScreen(
          context,
          UserOverview(
            user: widget.event.actor,
          ),
        ),
        child: CircleAvatar(
          backgroundImage: NetworkImage(widget.event.actor.avatarUrl),
        ),
      ),
      title: RichText(
        text: TextSpan(
          style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
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
      ),
      subtitle: Row(
        children: [
          Icon(Icons.info, size: 16),
          SizedBox(width: 8),
          Text(
            timeago.format(widget.event.createdAt),
            style: Theme.of(context).textTheme.caption,
          ),
        ],
      ),
    );
  }

  Widget _buildPullRequestEvent() {
    PullRequestEvent pullRequestEvent = PullRequestEvent.fromJson(widget.event.payload);
    if (pullRequestEvent.action == 'closed' && pullRequestEvent.pullRequest.merged) {}
    return ListTile(
      leading: GestureDetector(
        onTap: () => navigateToScreen(
          context,
          UserOverview(
            user: widget.event.actor,
          ),
        ),
        child: CircleAvatar(
          backgroundImage: NetworkImage(widget.event.actor.avatarUrl),
        ),
      ),
      title: RichText(
        text: TextSpan(
          style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
          children: <TextSpan>[
            TextSpan(
              text: '${pullRequestEvent.pullRequest.user.login} ',
            ),
            if (pullRequestEvent.action == 'closed' && pullRequestEvent.pullRequest.merged)
              TextSpan(
                text: 'merged pull request',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            if (pullRequestEvent.action == 'closed' && !pullRequestEvent.pullRequest.merged)
              TextSpan(
                text: 'closed pull request',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            if (pullRequestEvent.action != 'closed')
              TextSpan(
                text: '${pullRequestEvent.action} pull request',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            TextSpan(text: ' ${widget.event.repo.name}'),
            TextSpan(
              text: ' #${pullRequestEvent.number} ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      subtitle: Row(
        children: [
          Icon(MdiIcons.sourcePull, size: 16),
          SizedBox(width: 8),
          Text(
            timeago.format(widget.event.createdAt),
            style: Theme.of(context).textTheme.caption,
          ),
        ],
      ),
    );
  }
}
