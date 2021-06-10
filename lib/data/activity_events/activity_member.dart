import 'package:github/github.dart';
import 'package:github/hooks.dart';
import 'package:github_activity_feed/data/activity_events/activity_feed_item.dart';
import 'package:github_activity_feed/data/custom_repos.dart';

class ActivityMember implements ActivityFeedItem {
  ActivityMember({
    this.event,
    this.createdAt,
    this.repo,
  });

  /// The event itself, defined by the github package.
  final Event event;

  /// Event timestamp
  final DateTime createdAt;

  Repo repo;

  ActivityFeedItemType get type => ActivityFeedItemType.memberEvent;

  User get actor => event.actor;
  MemberEvent get memberEvent => MemberEvent.fromJson(event.payload);
  String get memberLogin => memberEvent.member.login;
  String get action => memberEvent.action;
}
