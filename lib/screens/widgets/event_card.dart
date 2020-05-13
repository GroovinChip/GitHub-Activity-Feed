import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:github/github.dart';
import 'package:github/hooks.dart';
import 'package:github_activity_feed/app/provided.dart';
import 'package:github_activity_feed/screens/mobile/user_overview.dart';
import 'package:timeago/timeago.dart' as timeago;

class EventCard extends StatefulWidget {
  EventCard({
    Key key,
    @required this.event,
  }) : super(key: key);

  final Event event;

  @override
  _EventCardState createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> with ProvidedState {
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
      case 'GollumEvent':
        _eventWidget = _buildGollumEvent();
        break;
      case 'IssueCommentEvent':
        _eventWidget = _buildIssueCommentEvent();
        break;
      case 'IssuesEvent':
        _eventWidget = _buildIssueEvent();
        break;
      case 'PullRequestEvent':
        _eventWidget = _buildPullRequestEvent();
        break;
      case 'PullRequestReviewCommentEvent':
        _eventWidget = _buildPullRequestReviewCommentEvent();
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
      child: _eventWidget != null
          ? ListTile(
              leading: GestureDetector(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => UserOverview(
                      user: widget.event.actor,
                    ),
                  ),
                ),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(widget.event.actor.avatarUrl),
                ),
              ),
              title: _eventWidget,
              subtitle: Text(
                timeago.format(widget.event.createdAt),
                style: Theme.of(context).textTheme.caption,
              ),
            )
          : Container(),
    );
  }

  Widget _buildCreateEvent() {
    Widget _createEventWidget;
    switch (widget.event.payload['ref_type']) {
      case 'branch':
        _createEventWidget = _buildCreateBranch();
        break;
      case 'repository':
        _createEventWidget = _buildCreateRepo();
        break;
      case 'tag':
        _createEventWidget = _buildCreateTag();
        break;
      default:
        break;
    }
    return _createEventWidget;
  }

  Widget _buildCreateBranch() {
    final _createBranchEventWidget = RichText(
      text: TextSpan(
        style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
        children: <TextSpan>[
          TextSpan(
            text: '${widget.event.actor.login} ',
          ),
          TextSpan(
            text: 'created ${widget.event.payload['ref_type']} ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(text: '${widget.event.payload['ref']} at ${widget.event.repo.name}'),
        ],
      ),
    );
    return _createBranchEventWidget;
  }

  Widget _buildCreateRepo() {
    final _createRepoWidget = RichText(
      text: TextSpan(
        style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
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
    return _createRepoWidget;
  }

  Widget _buildCreateTag() {
    final _createTagWidget = RichText(
      text: TextSpan(
        style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
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
    return _createTagWidget;
  }

  Widget _buildDeleteEvent() {
    final _deleteEventWidget = RichText(
      text: TextSpan(
        style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
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
        style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
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

  Widget _buildGollumEvent() {
    GollumEvent gollumEvent = GollumEvent.fromJson(widget.event.payload);
    WikiPage wikiPage = WikiPage.fromJson(gollumEvent.pages.first);
    final _gollumEventWidget = RichText(
      text: TextSpan(
        style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
        children: <TextSpan>[
          TextSpan(
            text: '${widget.event.actor.login}',
          ),
          TextSpan(
            text: ' ${wikiPage.action} ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: 'wiki page ',
          ),
          TextSpan(
            text: '${wikiPage.pageName} ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: 'at ${widget.event.repo.name}',
          ),
        ],
      ),
    );
    return _gollumEventWidget;
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
        style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
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
    );
    return _issueEventWidget;
  }

  Widget _buildPullRequestEvent() {
    PullRequestEvent pullRequestEvent = PullRequestEvent.fromJson(widget.event.payload);
    if (pullRequestEvent.action == 'closed' && pullRequestEvent.pullRequest.merged) {}
    final _pullRequestEventWidget = RichText(
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
          TextSpan(text: ' ${widget.event.repo.name} '),
          TextSpan(
            text: ' ${pullRequestEvent.number} ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
    return _pullRequestEventWidget;
  }

  Widget _buildPullRequestReviewCommentEvent() {
    PullRequest pullRequest = PullRequest.fromJson(widget.event.payload['pull_request']);
    final _pullRequestEventWidget = RichText(
      text: TextSpan(
        style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
        children: <TextSpan>[
          TextSpan(
            text: '${pullRequest.user.login} ',
          ),
          TextSpan(
            text: 'reviewed pull request',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(text: ' ${widget.event.repo.name}'),
          TextSpan(
            text: '#${pullRequest.number}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
    return _pullRequestEventWidget;
  }

  Widget _buildPushEvent() {
    Map<String, dynamic> pushEvent = widget.event.payload;
    int size = pushEvent['size'];
    final _pushEventWidget = RichText(
      text: TextSpan(
        style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
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
      text: TextSpan(
        style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
        children: <TextSpan>[
          TextSpan(text: widget.event.actor.login),
          TextSpan(
            text: ' starred',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(text: ' starred ${widget.event.repo.name}'),
        ],
      ),
    );
    return _watchEventWidget;
  }
}
