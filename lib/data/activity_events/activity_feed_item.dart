abstract class ActivityFeedItem {
  ActivityFeedItemType get type;
  DateTime get createdAt;
}

class ActivityFeedItemType {
  static const repoEvent = ActivityFeedItemType._('RepoEvent');
  static const forkEvent = ActivityFeedItemType._('ForkEvent');
  static const memberEvent = ActivityFeedItemType._('MemberEvent');
  static const publicEvent = ActivityFeedItemType._('PublicEvent');
  static const pushEvent = ActivityFeedItemType._('PushEvent');
  static const releaseEvent = ActivityFeedItemType._('ReleaseEvent');
  static const watchEvent = ActivityFeedItemType._('WatchEvent');

  static const values = [
    repoEvent,
    forkEvent,
    memberEvent,
    publicEvent,
    pushEvent,
    releaseEvent,
    watchEvent
  ];

  static ActivityFeedItemType from(String value) {
    return values.firstWhere((type) => type.name == value);
  }

  const ActivityFeedItemType._(this.name);

  final String name;
}
