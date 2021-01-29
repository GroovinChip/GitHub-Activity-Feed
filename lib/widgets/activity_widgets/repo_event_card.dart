import 'package:flutter/material.dart';
import 'package:github_activity_feed/app/provided.dart';
import 'package:github_activity_feed/data/activity_events/activity_repo.dart';
import 'package:github_activity_feed/utils/extensions.dart';
import 'package:github_activity_feed/widgets/activity_widgets/event_card.dart';
import 'package:github_activity_feed/widgets/activity_widgets/repo_preview.dart';
import 'package:github_activity_feed/widgets/user_widgets/user_avatar.dart';
import 'package:timeago/timeago.dart' as timeago;

class RepoEventCard extends StatefulWidget {
  const RepoEventCard({
    Key key,
    this.repoEvent,
  }) : super(key: key);

  final ActivityRepo repoEvent;

  @override
  _RepoEventCardState createState() => _RepoEventCardState();
}

class _RepoEventCardState extends State<RepoEventCard> with ProvidedState {
  @override
  Widget build(BuildContext context) {
    return EventCard(
      eventHeader: ListTile(
        /// Owner avatar
        leading: UserAvatar(
          avatarUrl: widget.repoEvent.action == 'created'
              ? widget.repoEvent.owner.avatarUrl
              : widget.repoEvent.actor.avatarUrl,
          userUrl: widget.repoEvent.action == 'created'
              ? widget.repoEvent.owner.url
              : widget.repoEvent.actorUrl,
          height: 44,
          width: 44,
        ),

        /// Actor with action
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: widget.repoEvent.actor.login,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: ' ${widget.repoEvent.action} repository ',
              ),
              WidgetSpan(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    widget.repoEvent.repo.name,
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
            Text(timeago.format(widget.repoEvent.createdAt, locale: 'en')),
      ),
      eventPreviewWebUrl: widget.repoEvent.repo.url,
      eventPreview: RepoPreview(
        avatarUrl: widget.repoEvent.action == 'created'
            ? widget.repoEvent.actor.avatarUrl
            : widget.repoEvent.owner.avatarUrl,
        repoName: widget.repoEvent.repo.nameWithOwner,
        repoDescription: widget.repoEvent.repo.description,
        watcherCount: widget.repoEvent.repo.watcherCount,
        stargazerCount: widget.repoEvent.repo.stargazerCount,
        forkCount: widget.repoEvent.repo.forkCount,
        primaryLanguage: widget.repoEvent.repo.languages.first,
      ),
    );
  }
}
