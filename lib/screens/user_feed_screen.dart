import 'package:flutter/material.dart';
import 'package:github/hooks.dart';
import 'package:github_activity_feed/app/provided.dart';
import 'package:github/github.dart';
import 'package:github_activity_feed/data/activity_events/activity_feed_item.dart';
import 'package:github_activity_feed/data/activity_events/activity_fork.dart';
import 'package:github_activity_feed/data/activity_events/activity_member.dart';
import 'package:github_activity_feed/data/activity_events/activity_pull_request.dart';
import 'package:github_activity_feed/data/activity_events/activity_repo.dart';
import 'package:github_activity_feed/services/graphql_service.dart';
import 'package:github_activity_feed/widgets/activity_widgets/fork_event_card.dart';
import 'package:github_activity_feed/widgets/activity_widgets/member_event_card.dart';
import 'package:github_activity_feed/widgets/activity_widgets/pr_event_card.dart';
import 'package:github_activity_feed/widgets/activity_widgets/repo_event_card.dart';
import 'package:github_activity_feed/widgets/loading_spinner.dart';
import 'package:github_activity_feed/widgets/user_widgets/user_avatar.dart';
import 'package:github_activity_feed/services/github_service.dart';

class UserFeedScreen extends StatefulWidget {
  const UserFeedScreen({
    Key key,
    @required this.username,
  }) : super(key: key);

  final String username;

  @override
  _UserFeedScreenState createState() => _UserFeedScreenState();
}

class _UserFeedScreenState extends State<UserFeedScreen> with ProvidedState {
  List<ActivityFeedItem> activityFeed = [];
  bool loading = false;

  @override
  void initState() {
    super.initState();
    getUserEvents();
  }

  Future<void> getUserEvents() async {
    GraphQLService graphQLService = GraphQLService(token: github.auth.token);
    activityFeed.clear();
    loading = true;
    final _events = await github.activity
        .listPublicEventsPerformedByUser(widget.username)
        .toList();

    for (final event in _events) {
      String repoQuery;
      String userQuery;
      ActivityRepo activityRepo = ActivityRepo(
        createdAt: event.createdAt,
        event: event,
      );

      switch (event.type) {
        case 'CreateEvent':
          repoQuery = event.repo.name.split('/').first;
          userQuery = event.actor.login;
          activityRepo.action = 'created';

          final repo = await graphQLService.getRepo(repoQuery, userQuery);

          if (repo != null) {
            activityRepo.repo = repo;
            activityFeed.add(activityRepo);
          }

          break;
        case 'ForkEvent':
          ActivityFork activityFork = ActivityFork(
            createdAt: event.createdAt,
            forkEvent: ForkEvent.fromJson(event.payload),
          );
          repoQuery = activityFork.forkEvent.forkee.name;
          userQuery = activityFork.forkEvent.forkee.fullName.split('/').first;

          final repo = await graphQLService.getRepo(repoQuery, userQuery);
          if (repo != null) {
            activityFork.repo = repo;
            activityFeed.add(activityFork);
          }

          break;
        case 'MemberEvent':
          ActivityMember activityMember = ActivityMember(
            event: event,
            createdAt: event.createdAt,
          );
          repoQuery = event.repo.name;
          userQuery = event.actor.login;

          final repo = await graphQLService.getRepo(repoQuery, userQuery);

          if (repo != null) {
            activityMember.repo = repo;
            activityFeed.add(activityMember);
          }

          break;
        case 'PullRequestEvent':
          ActivityPullRequest activityPullRequest = ActivityPullRequest(
            event: event,
            createdAt: event.createdAt,
          );

          activityFeed.add(activityPullRequest);

          break;
        case 'WatchEvent':
          repoQuery = event.repo.name.split('/').last;
          userQuery = event.repo.name.split('/').first;
          activityRepo.action = 'starred';

          final repo = await graphQLService.getRepo(repoQuery, userQuery);

          if (repo != null) {
            activityRepo.repo = repo;
            activityFeed.add(activityRepo);
          }

          break;
      }

      if (activityFeed.isNotEmpty) {
        activityFeed.sort((ActivityFeedItem item1, ActivityFeedItem item2) {
          return item2.createdAt.compareTo(item1.createdAt);
        });
      }

      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.username}\'s feed'),
      ),
      body: Builder(
        builder: (context) {
          if (loading) {
            return Center(
              child: LoadingSpinner(),
            );
          }
          return ListView.builder(
            itemCount: activityFeed.length,
            itemBuilder: (context, index) {
              switch (activityFeed[index].type) {
                case ActivityFeedItemType.repoEvent:
                  ActivityRepo activityRepo =
                  activityFeed[index];
                  return RepoEventCard(
                    repoEvent: activityRepo,
                  );
                case ActivityFeedItemType.forkEvent:
                  ActivityFork activityFork =
                  activityFeed[index];
                  return ForkEventCard(
                    activityFork: activityFork,
                  );
                case ActivityFeedItemType.memberEvent:
                  ActivityMember memberEvent =
                  activityFeed[index];
                  return MemberEventCard(
                    memberEvent: memberEvent,
                  );
                case ActivityFeedItemType.pullRequestEvent:
                  ActivityPullRequest activityPullRequest =
                  activityFeed[index];
                  return PrEventCard(
                    pr: activityPullRequest,
                  );
                default:
                  return const SizedBox.shrink();
              }
            },
          );
        }
      ),
      /*body: FutureBuilder<List<Event>>(
        future:
            github.activity.listEventsPerformedByUser(widget.username).toList(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: LoadingSpinner(),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                final event = snapshot.data[index];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            UserAvatar(
                              width: 44,
                              height: 44,
                              avatarUrl: event.actor.avatarUrl,
                              userUrl: event.actor.htmlUrl,
                            ),
                            const SizedBox(width: 8.0),
                            Expanded(
                              child: Text(event.action),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),*/
    );
  }
}
