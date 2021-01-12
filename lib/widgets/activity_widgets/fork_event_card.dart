import 'package:flutter/material.dart';
import 'package:github/hooks.dart';
import 'package:github_activity_feed/utils/printers.dart';
import 'package:github_activity_feed/widgets/activity_widgets/count_item.dart';
import 'package:github_activity_feed/widgets/activity_widgets/event_card.dart';
import 'package:github_activity_feed/widgets/user_widgets/user_avatar.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'language_label.dart';

class ForkEventCard extends StatefulWidget {
  ForkEventCard({
    Key key,
    this.forkEvent,
    this.forkedFrom,
  }) : super(key: key);

  final ForkEvent forkEvent;
  final String forkedFrom;

  @override
  _ForkEventCardState createState() => _ForkEventCardState();
}

class _ForkEventCardState extends State<ForkEventCard> {
  @override
  Widget build(BuildContext context) {
    //printFormattedJson(widget.forkEvent.toJson());
    return EventCard(
      eventHeader: ListTile(
        /// Owner avatar
        leading: UserAvatar(
          avatarUrl: widget.forkEvent.forkee.owner.avatarUrl,
          userUrl: widget.forkEvent.forkee.owner.htmlUrl,
          height: 44,
          width: 44,
        ),

        /// Actor with action
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '${widget.forkEvent.forkee.owner.login} ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: 'forked ',
              ),
              WidgetSpan(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    '${widget.forkedFrom}/${widget.forkEvent.forkee.name}',
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
            timeago.format(widget.forkEvent.forkee.createdAt, locale: 'en')),
      ),
      eventPreview: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.forkEvent.forkee.fullName,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(widget.forkEvent.forkee.description ?? 'No description'),
          SizedBox(height: 8),
          Row(
            children: [
              CountItem(
                iconData: Icons.remove_red_eye_outlined,
                countItem: widget.forkEvent.forkee.watchersCount,
              ),
              SizedBox(width: 16),
              CountItem(
                iconData: Icons.star_outline,
                countItem: widget.forkEvent.forkee.stargazersCount,
              ),
              SizedBox(width: 16),
              CountItem(
                iconData: MdiIcons.sourceFork,
                countItem: widget.forkEvent.forkee.forksCount,
              ),
              SizedBox(width: 16),
              LanguageLabel(
                language: widget.forkEvent.forkee.language,
              ),
            ],
          ),
        ],
      ),
      //eventPreviewWebUrl: 'https://github.com/${widget.forkEvent.repo.name}',
      eventPreviewWebUrl: widget.forkEvent.forkee.htmlUrl,
    );
  }
}
