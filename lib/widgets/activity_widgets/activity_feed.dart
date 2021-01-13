import 'package:flutter/material.dart';
import 'package:github/hooks.dart';
import 'package:github_activity_feed/app/provided.dart';
import 'package:github_activity_feed/data/activity_feed_item.dart';
import 'package:github_activity_feed/utils/printers.dart';
import 'package:github_activity_feed/widgets/activity_widgets/create_event_card.dart';
import 'package:github_activity_feed/widgets/activity_widgets/fork_event_card.dart';
import 'package:github_activity_feed/widgets/watch_event_card.dart';

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
            child: CircularProgressIndicator(),
          );
        } else {
          return Scrollbar(
            child: ListView.builder(
              itemCount: githubService.activityFeed.length,
              itemBuilder: (context, index) {
                switch (githubService.activityFeed[index].type) {
                  case 'CreateEvent':
                    //printFormattedJson(githubService.activityFeed[index].toJson());
                    return CreateEventCard(
                      createEvent: githubService.activityFeed[index],
                    );
                  case 'ForkEvent':
                    String forkedFrom = githubService.activityFeed[index].repo.name
                        .split('/')
                        .first;
                    return ForkEventCard(
                      forkEvent: ForkEvent.fromJson(
                          githubService.activityFeed[index].payload),
                      forkedFrom: forkedFrom,
                    );
                  case 'MemberEvent':
                  //printFormattedJson(activityFeed[index].toJson());
                    return Container();
                //return Text(activityFeed[index].type);
                  case 'PublicEvent':
                    return Container();
                //return Text(activityFeed[index].type);
                  case 'PushEvent':
                    return Container();
                //return Text(activityFeed[index].type);
                  case 'ReleaseEvent':
                    return Container();
                //return Text(activityFeed[index].type);
                  case 'WatchEvent':
                    return WatchEventCard(
                      watchEvent: githubService.activityFeed[index],
                    );
                //return Text(activityFeed[index].type);
                  default:
                    return Container();
                //return Text(activityFeed[index].type);
                }
              },
            ),
          );

          /*return Scrollbar(
            child: ListView.builder(
              itemCount: githubService.feedV2.length,
              itemBuilder: (context, index) {
                switch (githubService.feedV2[index].type) {
                  case ActivityFeedItemType.createEvent:
                    return ListTile(
                      title: Text(githubService.feedV2[index].repository.name),
                    );
                  default:
                    return Container();
                  //return Text(activityFeed[index].type);
                }
              },
            ),
          );*/
        }
      },
    );
  }
}
