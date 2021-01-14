import 'package:flutter/material.dart';
import 'package:github_activity_feed/app/provided.dart';
import 'package:github_activity_feed/data/activity_events.dart';
import 'package:github_activity_feed/widgets/activity_widgets/count_item.dart';
import 'package:github_activity_feed/widgets/activity_widgets/event_card.dart';
import 'package:github_activity_feed/widgets/activity_widgets/language_label.dart';
import 'package:github_activity_feed/widgets/user_widgets/user_avatar.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;

//todo: some graphQL trickery to get the repo, or language info, etc?
class CreateEventCard extends StatefulWidget {
  const CreateEventCard({
    Key key,
    this.createEvent,
  }) : super(key: key);

  final ActivityCreate createEvent;

  @override
  _CreateEventCardState createState() => _CreateEventCardState();
}

class _CreateEventCardState extends State<CreateEventCard> with ProvidedState {
  @override
  Widget build(BuildContext context) {
    return EventCard(
      eventHeader: ListTile(
        /// Owner avatar
        leading: UserAvatar(
          avatarUrl: widget.createEvent.owner.avatarUrl,
          userUrl: widget.createEvent.owner.url,
          height: 44,
          width: 44,
        ),

        /// Actor with action
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: widget.createEvent.actor.login,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: ' created repository ',
              ),
              WidgetSpan(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    widget.createEvent.repo.name,
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
            Text(timeago.format(widget.createEvent.createdAt, locale: 'en')),
      ),
      eventPreviewWebUrl: widget.createEvent.repo.url,
      eventPreview: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.createEvent.repo.nameWithOwner,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(widget.createEvent.repo.description ?? 'No description'),
          SizedBox(height: 8),
          Row(
            children: [
              CountItem(
                iconData: Icons.remove_red_eye_outlined,
                countItem: widget.createEvent.repo.watcherCount,
              ),
              SizedBox(width: 16),
              CountItem(
                iconData: Icons.star_outline,
                countItem: widget.createEvent.repo.stargazerCount,
              ),
              SizedBox(width: 16),
              CountItem(
                iconData: MdiIcons.sourceFork,
                countItem: widget.createEvent.repo.forkCount,
              ),
              SizedBox(width: 16),

              /*LanguageLabel(
                language: widget.createEvent.repository.language,
              ),*/
            ],
          ),
        ],
      ),
    );
  }
}
