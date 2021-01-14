import 'package:flutter/material.dart';
import 'package:github_activity_feed/data/activity_events.dart';
import 'package:github_activity_feed/widgets/activity_widgets/count_item.dart';
import 'package:github_activity_feed/widgets/activity_widgets/event_card.dart';
import 'package:github_activity_feed/widgets/user_widgets/user_avatar.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart' as url_launcher;

import 'language_label.dart';

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
              color: Theme.of(context).colorScheme.onBackground,
              fontSize: 16,
            ),
          ),
        ),

        /// Fuzzy timestamp
        subtitle:
            Text(timeago.format(widget.activityFork.createdAt, locale: 'en')),

        trailing: IconButton(
          tooltip: 'See this fork',
          icon: Icon(MdiIcons.sourceFork),
          onPressed: () => url_launcher.launch(widget.activityFork.repo.url),
        ),
      ),
      eventPreview: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UserAvatar(
                avatarUrl: widget.activityFork.repo.parent.owner.avatarUrl,
                height: 25,
                width: 25,
              ),
              SizedBox(width: 8),
              Expanded(
                child: FittedBox(
                  alignment: Alignment.topLeft,
                  fit: BoxFit.scaleDown,
                  child: Text(
                    widget.activityFork.parent.nameWithOwner,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 4),
          Text(widget.activityFork.parent.description ?? 'No description'),
          SizedBox(height: 8),
          Row(
            children: [
              CountItem(
                iconData: Icons.remove_red_eye_outlined,
                countItem: widget.activityFork.parent.watcherCount,
              ),
              SizedBox(width: 16),
              CountItem(
                iconData: Icons.star_outline,
                countItem: widget.activityFork.parent.stargazerCount,
              ),
              SizedBox(width: 16),
              CountItem(
                iconData: MdiIcons.sourceFork,
                countItem: widget.activityFork.parent.forkCount,
              ),
              Spacer(),
              LanguageLabel(
                language: widget.activityFork.parent.languages.first,
              ),
              SizedBox(width: 8),
            ],
          ),
        ],
      ),
      eventPreviewWebUrl: widget.activityFork.parent.url,
    );
  }
}
