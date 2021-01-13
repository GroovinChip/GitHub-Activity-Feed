import 'package:github/github.dart';
import 'package:github/hooks.dart';
import 'package:github_activity_feed/data/activity_feed_item.dart';
import 'package:github_activity_feed/data/parent_repo.dart';

/// Defines a CreateEvent.
class ActivityCreate implements ActivityFeedItem {
  ActivityCreate({
    this.event,
    this.createdAt,
    this.repository,
  });

  /// The event itself, defined by the github package.
  ///
  /// Does not contain full details. Hence the [repository] value.
  Event event;

  /// Event timestamp
  DateTime createdAt;

  /// The full details for the created repository
  Repository repository;

  ActivityFeedItemType get type => ActivityFeedItemType.createEvent;
  User get actor => event.actor;
  UserInformation get owner => repository.owner;
}

/// Defines a ForkEvent
class ActivityFork implements ActivityFeedItem {
  ActivityFork({
    this.forkEvent,
    this.createdAt,
    this.parent,
    this.parentOwner,
  });

  /// The event itself, defined by the github package.
  ///
  /// Does not contain details about the [parent] repository. Does not contain
  /// details about the user who owns the [parent] repository.
  ForkEvent forkEvent;

  /// Event timestamp
  DateTime createdAt;

  /// Full details about the parent repository
  ParentRepo parent;

  /// Full details about the owner of the parent repository
  User parentOwner;

  ActivityFeedItemType get type => ActivityFeedItemType.forkEvent;
  UserInformation get actor => forkEvent.forkee.owner;
  Repository get forked => forkEvent.forkee;
}
