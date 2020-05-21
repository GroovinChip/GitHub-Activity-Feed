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

  final Event event;

  @override
  _EventCardState createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> with ProvidedState {
  Widget _eventWidget;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print(widget.event.type);
    _buildActivityWidgetByType();
  }

  void _buildActivityWidgetByType() {
    switch (widget.event.type) {
      case 'CommitCommentEvent':
        _eventWidget = _buildCommitCommentEvent();
        break;
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
      case 'PublicEvent':
        _eventWidget = _buildPublicEvent();
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
      case 'ReleaseEvent':
        _eventWidget = _buildReleaseEvent();
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
      child: _eventWidget,
    );
  }

  Widget _buildCommitCommentEvent() {
    CommitComment commitComment = CommitComment.fromJson(widget.event.payload['comment']);
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
              text: '${widget.event.actor.login}',
            ),
            TextSpan(
              text: ' commented on commit ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(text: '${widget.event.repo.name}'),
            TextSpan(
              text: '@${commitComment.commitId.substring(0, 10)}',
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            ),
          ],
        ),
      ),
      subtitle: Row(
        children: [
          Icon(Icons.comment, size: 16),
          SizedBox(width: 8),
          Text(
            timeago.format(widget.event.createdAt),
            style: Theme.of(context).textTheme.caption,
          ),
        ],
      ),
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
      ),
      subtitle: Row(
        children: [
          Icon(MdiIcons.sourceBranch, size: 16),
          SizedBox(width: 8),
          Text(
            timeago.format(widget.event.createdAt),
            style: Theme.of(context).textTheme.caption,
          ),
        ],
      ),
    );
  }

  Widget _buildCreateRepo() {
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
      ),
      subtitle: Row(
        children: [
          Icon(MdiIcons.sourceRepository, size: 16),
          SizedBox(width: 8),
          Text(
            timeago.format(widget.event.createdAt),
            style: Theme.of(context).textTheme.caption,
          ),
        ],
      ),
    );
  }

  Widget _buildCreateTag() {
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
      ),
      subtitle: Row(
        children: [
          Icon(MdiIcons.tag, size: 16),
          SizedBox(width: 8),
          Text(
            timeago.format(widget.event.createdAt),
            style: Theme.of(context).textTheme.caption,
          ),
        ],
      ),
    );
  }

  Widget _buildDeleteEvent() {
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
      ),
      subtitle: Row(
        children: [
          Icon(Icons.delete, size: 16),
          SizedBox(width: 8),
          Text(
            timeago.format(widget.event.createdAt),
            style: Theme.of(context).textTheme.caption,
          ),
        ],
      ),
    );
  }

  Widget _buildForkEvent() {
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
      ),
      subtitle: Row(
        children: [
          Icon(MdiIcons.sourceFork, size: 16),
          SizedBox(width: 8),
          Text(
            timeago.format(widget.event.createdAt),
            style: Theme.of(context).textTheme.caption,
          ),
        ],
      ),
    );
  }

  Widget _buildGollumEvent() {
    GollumEvent gollumEvent = GollumEvent.fromJson(widget.event.payload);
    WikiPage wikiPage = WikiPage.fromJson(gollumEvent.pages.first);
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
      ),
      subtitle: Row(
        children: [
          Icon(Icons.book, size: 16),
          SizedBox(width: 8),
          Text(
            timeago.format(widget.event.createdAt),
            style: Theme.of(context).textTheme.caption,
          ),
        ],
      ),
    );
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
      ),
      subtitle: Row(
        children: [
          Icon(Icons.comment, size: 16),
          SizedBox(width: 8),
          Text(
            timeago.format(widget.event.createdAt),
            style: Theme.of(context).textTheme.caption,
          ),
        ],
      ),
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

  Widget _buildPublicEvent() {
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
              text: '${widget.event.actor.login} made ',
            ),
            TextSpan(
              text: '${widget.event.repo.name}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(text: ' public'),
          ],
        ),
      ),
      subtitle: Row(
        children: [
          Icon(MdiIcons.partyPopper, size: 16),
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
            TextSpan(text: ' ${widget.event.repo.name} '),
            TextSpan(
              text: ' ${pullRequestEvent.number} ',
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

  Widget _buildPullRequestReviewCommentEvent() {
    PullRequest pullRequest = PullRequest.fromJson(widget.event.payload['pull_request']);
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
      ),
      subtitle: Row(
        children: [
          Icon(Icons.comment, size: 16),
          SizedBox(width: 8),
          Text(
            timeago.format(widget.event.createdAt),
            style: Theme.of(context).textTheme.caption,
          ),
        ],
      ),
    );
  }

  Widget _buildPushEvent() {
    Map<String, dynamic> pushEvent = widget.event.payload;
    int size = pushEvent['size'];
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
      ),
      subtitle: Row(
        children: [
          Icon(MdiIcons.sourceCommit, size: 16),
          SizedBox(width: 8),
          Text(
            timeago.format(widget.event.createdAt),
            style: Theme.of(context).textTheme.caption,
          ),
        ],
      ),
    );
  }

  Widget _buildReleaseEvent() {
    Release release = Release.fromJson(widget.event.payload['release']);
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
            TextSpan(text: widget.event.actor.login),
            TextSpan(
              text: ' released',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: ' ${release.name}'),
            TextSpan(
              text: ' at ',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: ' ${widget.event.repo.name}'),
          ],
        ),
      ),
      subtitle: Row(
        children: [
          Icon(MdiIcons.application, size: 16),
          SizedBox(width: 8),
          Text(
            timeago.format(widget.event.createdAt),
            style: Theme.of(context).textTheme.caption,
          ),
        ],
      ),
    );
  }

  Widget _buildWatchEvent() {
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
            TextSpan(text: widget.event.actor.login),
            TextSpan(
              text: ' starred',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: ' ${widget.event.repo.name}'),
          ],
        ),
      ),
      subtitle: Row(
        children: [
          Icon(Icons.star, size: 16),
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
