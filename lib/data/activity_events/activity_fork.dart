import 'package:github/github.dart';
import 'package:github/hooks.dart';
import 'package:github_activity_feed/data/activity_events/activity_feed_item.dart';
import 'package:github_activity_feed/data/custom_repos.dart';

/// Defines a ForkEvent
class ActivityFork implements ActivityFeedItem {
  ActivityFork({
    this.forkEvent,
    this.createdAt,
    this.repo,
  });

  /// The event itself, defined by the github package.
  ///
  /// Does not contain details about the [repo] repository. Does not contain
  /// details about the user who owns the [repo] repository.
  ForkEvent forkEvent;

  /// Event timestamp
  DateTime createdAt;

  /// Custom details about the parent repository
  Repo repo;

  ActivityFeedItemType get type => ActivityFeedItemType.forkEvent;
  UserInformation get actor => forkEvent.forkee.owner;
  ParentRepo get parent => repo.parent;
  Owner get parentOwner => repo.parent.owner;
}
