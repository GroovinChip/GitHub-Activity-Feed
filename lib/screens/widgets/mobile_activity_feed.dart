import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:github/github.dart';
import 'package:github_activity_feed/screens/mobile/event_details_screen.dart';
import 'package:github_activity_feed/screens/widgets/activity_card.dart';

class MobileActivityFeed extends StatefulWidget {
  MobileActivityFeed({
    Key key,
    @required this.events,
  }) : super(key: key);

  final List<Event> events;

  @override
  _MobileActivityFeedState createState() => _MobileActivityFeedState();
}

class _MobileActivityFeedState extends State<MobileActivityFeed> {
  List<Event> get events => widget.events;

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: ListView.builder(
        itemCount: events.length,
        padding: const EdgeInsets.only(left: 8, right: 8),
        itemBuilder: (BuildContext context, int index) {
          final event = events[index];
          return OpenContainer(
            closedColor: Theme.of(context).canvasColor,
            closedBuilder: (BuildContext context, action) {
              return ActivityCard(event: event);
            },
            openBuilder: (BuildContext context, action) {
              return EventDetailsScreen(event: event);
            },
          );
        },
      ),
    );
  }
}
