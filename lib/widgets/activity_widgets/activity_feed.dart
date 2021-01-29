import 'package:flutter/material.dart';
import 'package:github_activity_feed/app/provided.dart';
import 'package:github_activity_feed/data/activity_events/activity_feed_item.dart';
import 'package:github_activity_feed/data/activity_events/activity_fork.dart';
import 'package:github_activity_feed/data/activity_events/activity_repo.dart';
import 'package:github_activity_feed/widgets/activity_widgets/fork_event_card.dart';
import 'package:github_activity_feed/widgets/activity_widgets/repo_event_card.dart';
import 'package:github_activity_feed/widgets/loading_spinner.dart';

class ActivityFeed extends StatefulWidget {
  @override
  _ActivityFeedState createState() => _ActivityFeedState();
}

class _ActivityFeedState extends State<ActivityFeed> with ProvidedState {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: githubService.loadingFeed,
      initialData: githubService.loadingFeed.value,
      builder: (context, snapshot) {
        if (snapshot.data) {
          return Center(
            child: LoadingSpinner(),
          );
        } else {
          return Scrollbar(
            child: ListView.builder(
              padding: EdgeInsets.all(8),
              itemCount: githubService.activityFeed.length,
              itemBuilder: (context, index) {
                switch (githubService.activityFeed[index].type) {
                  case ActivityFeedItemType.repoEvent:
                    ActivityRepo activityRepo =
                        githubService.activityFeed[index];
                    return RepoEventCard(
                      repoEvent: activityRepo,
                    );
                  case ActivityFeedItemType.forkEvent:
                    ActivityFork activityFork =
                        githubService.activityFeed[index];
                    return ForkEventCard(
                      activityFork: activityFork,
                    );
                  default:
                    return Container();
                }
              },
            ),
          );
        }
      },
    );
  }
}
