import 'package:github/github.dart';
import 'package:github_activity_feed/data/activity_feed_item.dart';

class ActivityCreateEvent implements ActivityFeedItem {
  ActivityCreateEvent({
    this.event,
    this.createdAt,
    this.repository,
  });

  Event event;
  DateTime createdAt;
  Repository repository;

  ActivityFeedItemType get type => ActivityFeedItemType.createEvent;
}
