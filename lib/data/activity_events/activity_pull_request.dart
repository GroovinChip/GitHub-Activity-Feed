import 'package:github/github.dart';
import 'package:github_activity_feed/data/activity_events/activity_feed_item.dart';
import 'package:groovin_widgets/groovin_widgets.dart';

/// Defines an event related to a Pull Request
class ActivityPullRequest implements ActivityFeedItem {
  ActivityPullRequest({
    this.event,
    this.createdAt,
  });

  /// The event itself, defined by the github package.
  final Event event;

  /// Event timestamp
  DateTime createdAt;

  ActivityFeedItemType get type => ActivityFeedItemType.pullRequestEvent;
  User get actor => event.actor;
  PullRequest get pullRequest =>
      PullRequest.fromJson(event.payload['pull_request']);

  void printPayload() => printFormattedJson(event.payload);
}
