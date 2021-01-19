import 'package:flutter/material.dart';
import 'package:github_activity_feed/app/provided.dart';
import 'package:github_activity_feed/data/activity_events/activity_repo.dart';
import 'package:github_activity_feed/utils/extensions.dart';
import 'package:github_activity_feed/widgets/activity_widgets/count_item.dart';
import 'package:github_activity_feed/widgets/activity_widgets/event_card.dart';
import 'package:github_activity_feed/widgets/activity_widgets/language_label.dart';
import 'package:github_activity_feed/widgets/user_widgets/user_avatar.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
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
          //fixme:
          userUrl: widget.repoEvent.action == 'created'
              ? widget.repoEvent.owner.url
              : 'https://github.com/${widget.repoEvent.actor.login}',
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
      eventPreview: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.repoEvent.action == 'created')
            Text(
              widget.repoEvent.repo.nameWithOwner,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          if (widget.repoEvent.action == 'starred')
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UserAvatar(
                  avatarUrl: widget.repoEvent.repo.owner.avatarUrl,
                  height: 25,
                  width: 25,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: FittedBox(
                    alignment: Alignment.topLeft,
                    fit: BoxFit.scaleDown,
                    child: Text(
                      widget.repoEvent.repo.nameWithOwner,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          SizedBox(height: 4),
          Text(widget.repoEvent.repo.description ?? 'No description'),
          SizedBox(height: 8),
          Row(
            children: [
              CountItem(
                iconData: Icons.remove_red_eye_outlined,
                countItem: widget.repoEvent.repo.watcherCount,
              ),
              SizedBox(width: 16),
              CountItem(
                iconData: Icons.star_outline,
                countItem: widget.repoEvent.repo.stargazerCount,
              ),
              SizedBox(width: 16),
              CountItem(
                iconData: MdiIcons.sourceFork,
                countItem: widget.repoEvent.repo.forkCount,
              ),
              Spacer(),
              LanguageLabel(
                language: widget.repoEvent.repo.languages.first,
              ),
              SizedBox(width: 8),
            ],
          ),
        ],
      ),
    );
  }
}
