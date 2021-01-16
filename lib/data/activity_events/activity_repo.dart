import 'package:github/github.dart';
import 'package:github_activity_feed/data/activity_events/activity_feed_item.dart';
import 'package:github_activity_feed/data/custom_repos.dart';

/// Defines an event related to a repository, like creating or starring.
class ActivityRepo implements ActivityFeedItem {
  ActivityRepo({
    this.event,
    this.createdAt,
    this.action,
    this.repo,
  });

  /// The event itself, defined by the github package.
  Event event;

  /// Event timestamp
  DateTime createdAt;

  /// 'Created' or 'Starred'
  String action;

  /// Custom details for the created repository
  Repo repo;

  ActivityFeedItemType get type => ActivityFeedItemType.repoEvent;
  User get actor => event.actor;
  Owner get owner => repo.owner;
}