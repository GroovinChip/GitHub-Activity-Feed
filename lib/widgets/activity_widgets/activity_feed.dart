import 'package:flutter/material.dart';

class ActivityFeed extends StatefulWidget {
  @override
  _ActivityFeedState createState() => _ActivityFeedState();
}

class _ActivityFeedState extends State<ActivityFeed> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getFeedData();
  }

  Future<void> getFeedData() async {
    //
    buildActivityFeed();
  }

  void buildActivityFeed() {
    //
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Coming soon'),
    );
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
