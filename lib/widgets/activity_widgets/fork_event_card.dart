import 'package:flutter/material.dart';
import 'package:github_activity_feed/data/activity_events/activity_fork.dart';
import 'package:github_activity_feed/utils/extensions.dart';
import 'package:github_activity_feed/widgets/activity_widgets/event_card.dart';
import 'package:github_activity_feed/widgets/activity_widgets/repo_preview.dart';
import 'package:github_activity_feed/widgets/octicons/oct_icons24_icons.dart';
import 'package:github_activity_feed/widgets/user_widgets/user_avatar.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart' as url_launcher;

//todo: get parent repo, show that instead, or both?
class ForkEventCard extends StatefulWidget {
  ForkEventCard({
    Key key,
    this.activityFork,
  }) : super(key: key);

  final ActivityFork activityFork;

  @override
  _ForkEventCardState createState() => _ForkEventCardState();
}

class _ForkEventCardState extends State<ForkEventCard> {
  @override
  Widget build(BuildContext context) {
    return EventCard(
      eventHeader: ListTile(
        /// Owner avatar
        leading: UserAvatar(
          avatarUrl: widget.activityFork.actor.avatarUrl,
          userUrl: widget.activityFork.actor.htmlUrl,
          height: 44,
          width: 44,
        ),

        /// Actor with action
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: widget.activityFork.actor.login,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: ' forked ',
              ),
              WidgetSpan(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    widget.activityFork.repo.name,
                    maxLines: 1,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
            style: TextStyle(
              color: context.theme.textTheme.bodyText1.color,
              fontSize: 16,
            ),
          ),
        ),

        /// Fuzzy timestamp
        subtitle:
            Text(timeago.format(widget.activityFork.createdAt, locale: 'en')),

        trailing: IconButton(
          tooltip: 'See this fork',
          icon: Icon(OctIcons24.git_fork_24),
          onPressed: () => url_launcher.launch(widget.activityFork.repo.url),
        ),
      ),
      eventPreviewWebUrl: widget.activityFork.parent.url,
      eventPreview: RepoPreview(
        avatarUrl: widget.activityFork.repo.parent.owner.avatarUrl,
        repoName: widget.activityFork.parent.nameWithOwner,
        repoDescription: widget.activityFork.parent.description,
        watcherCount: widget.activityFork.parent.watcherCount,
        stargazerCount: widget.activityFork.parent.stargazerCount,
        forkCount: widget.activityFork.parent.forkCount,
        primaryLanguage: widget.activityFork.parent.languages.first,
      ),
    );
  }
}
