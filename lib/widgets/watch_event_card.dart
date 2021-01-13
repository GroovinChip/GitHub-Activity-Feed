import 'package:flutter/material.dart';
import 'package:github/github.dart';
import 'package:github_activity_feed/utils/printers.dart';
import 'package:github_activity_feed/widgets/activity_widgets/count_item.dart';
import 'package:github_activity_feed/widgets/activity_widgets/event_card.dart';
import 'package:github_activity_feed/widgets/activity_widgets/language_label.dart';
import 'package:github_activity_feed/widgets/user_widgets/user_avatar.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;

class WatchEventCard extends StatefulWidget {
  WatchEventCard({
    Key key,
    this.watchEvent,
  }) : super(key: key);

  final Event watchEvent;

  @override
  _WatchEventCardState createState() => _WatchEventCardState();
}

class _WatchEventCardState extends State<WatchEventCard> {
  @override
  Widget build(BuildContext context) {
    //printFormattedJson(widget.watchEvent.toJson());
    return EventCard(
      eventHeader: ListTile(
        /// Owner avatar
        leading: UserAvatar(
          avatarUrl: widget.watchEvent.actor.avatarUrl,
          userUrl: widget.watchEvent.actor.htmlUrl,
          height: 44,
          width: 44,
        ),

        /// Actor with action
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '${widget.watchEvent.actor.login} ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: 'starred ',
              ),
              WidgetSpan(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    widget.watchEvent.repo.name,
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
        subtitle: Text(
            timeago.format(widget.watchEvent.createdAt, locale: 'en')),
      ),
      eventPreview: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.watchEvent.repo.name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(widget.watchEvent.repo.description ?? 'No description'),
          SizedBox(height: 8),
          Row(
            children: [
              CountItem(
                iconData: Icons.remove_red_eye_outlined,
                countItem: widget.watchEvent.repo.watchersCount,
              ),
              SizedBox(width: 16),
              CountItem(
                iconData: Icons.star_outline,
                countItem: widget.watchEvent.repo.stargazersCount,
              ),
              SizedBox(width: 16),
              CountItem(
                iconData: MdiIcons.sourceFork,
                countItem: widget.watchEvent.repo.forksCount,
              ),
              SizedBox(width: 16),
              LanguageLabel(
                language: widget.watchEvent.repo.language,
              ),
            ],
          ),
        ],
      ),
      eventPreviewWebUrl: widget.watchEvent.repo.htmlUrl,
    );
  }
}
