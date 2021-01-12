import 'package:flutter/material.dart';
import 'package:github/github.dart';
import 'package:github_activity_feed/app/provided.dart';
import 'package:github_activity_feed/widgets/activity_widgets/event_card.dart';
import 'package:github_activity_feed/widgets/user_widgets/user_avatar.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart' as url_launcher;

class CreateEventCard extends StatefulWidget {
  const CreateEventCard({
    Key key,
    this.createEvent,
  }) : super(key: key);

  final Event createEvent;

  @override
  _CreateEventCardState createState() => _CreateEventCardState();
}

class _CreateEventCardState extends State<CreateEventCard> with ProvidedState {
  @override
  Widget build(BuildContext context) {
    return EventCard(
      //fixme: tap does nothing
      launchInBrowser: () => print('https://github.com/${widget.createEvent.repo.name}'),
      eventHeader: ListTile(
        /// Owner avatar
        leading: GestureDetector(
          //onTap: () => launch(gist.owner.url),
          child: UserAvatar(
            avatarUrl: widget.createEvent.actor.avatarUrl,
            height: 44,
            width: 44,
          ),
        ),

        /// Actor with action
        title: Text(
          '${widget.createEvent.actor.login} created a repository',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onBackground,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),

        /// Fuzzy timestamp
        subtitle: Text(timeago.format(widget.createEvent.createdAt, locale: 'en')),
      ),
      eventPreview: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.createEvent.repo.name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(widget.createEvent.repo.description ?? 'No description'),
          SizedBox(height: 8),
          Row(
            children: [
              //todo: create specific widgets for below

              Icon(Icons.remove_red_eye),
              SizedBox(width: 8),
              Text('${widget.createEvent.repo.watchersCount ?? 0}'),
              SizedBox(width: 16),
              Icon(Icons.star_outline),
              SizedBox(width: 8),
              Text('${widget.createEvent.repo.stargazersCount ?? 0}'),
              SizedBox(width: 16),
              Icon(MdiIcons.sourceFork),
              SizedBox(width: 8),
              Text('${widget.createEvent.repo.forksCount ?? 0}'),
            ],
          ),
        ],
      ),
    );
  }
}
