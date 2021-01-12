import 'package:flutter/material.dart';
import 'package:github/github.dart';
import 'package:github_activity_feed/app/provided.dart';
import 'package:github_activity_feed/utils/printers.dart';

class ActivityFeed extends StatefulWidget {
  @override
  _ActivityFeedState createState() => _ActivityFeedState();
}

class _ActivityFeedState extends State<ActivityFeed> with ProvidedState {
  Stream activityStream;
  List<Event> activityFeed = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    getFeedData();
  }

  void getFeedData() {
    activityStream = githubService.listAuthUserReceivedEvents(pages: 30);
    activityStream.listen((event) {
      activityFeed.add(event);
    }).onDone(() {
      print('Finished loading feed');
      setState(() => loading = false);
      print(loading);
    });
  }

  void buildActivityFeed() {
    //
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      //print(snapshot.data.length);
      return ListView.builder(
        itemCount: activityFeed.length,
        itemBuilder: (context, index) {
          switch (activityFeed[index].type) {
            case 'CreateEvent':
              //printFormattedJson(activityFeed[index].toJson());
              return ListTile(
                title: Text(activityFeed[index].type),
                subtitle: Text(activityFeed[index].createdAt.toString()),
              );
            case 'ForkEvent':
              return Container();
              //return Text(activityFeed[index].type);
            case 'MemberEvent':
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
              return Container();
              //return Text(activityFeed[index].type);
            default:
              return Container();
              //return Text(activityFeed[index].type);
          }
        },
      );
    }
    /*return Scrollbar(
      child: ListView.builder(
        itemCount: activityFeed.length,
        padding: const EdgeInsets.all(8.0),
        itemBuilder: (BuildContext context, int index) {
          switch (activityFeed[index].type.name) {
            case 'Gist':
              return GistCard(gist: activityFeed[index]);
            case 'Issue':
              return IssueCard(issue: activityFeed[index]);
            case 'IssueComment':
              return IssueCommentCard(comment: activityFeed[index]);
            case 'PullRequest':
              return PullRequestCard(pullRequest: activityFeed[index]);
            case 'StarredRepositoryEdge':
              return StarCard(
                starredRepoEdge: activityFeed[index],
              );
            default:
              return Container();
          }
        },
      ),
    );*/
  }
}
