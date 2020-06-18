import 'package:flutter/material.dart';
import 'package:github_activity_feed/data/activity_feed_models.dart';
import 'package:github_activity_feed/data/gist.dart';
import 'package:github_activity_feed/services/graphql_service.dart';
import 'package:github_activity_feed/widgets/activity_widgets/gist_card.dart';
import 'package:github_activity_feed/widgets/activity_widgets/issue_card.dart';
import 'package:github_activity_feed/widgets/activity_widgets/issue_comment_card.dart';
import 'package:github_activity_feed/widgets/activity_widgets/pull_request_card.dart';
import 'package:github_activity_feed/widgets/activity_widgets/star_card.dart';
import 'package:provider/provider.dart';

class ActivityFeed extends StatefulWidget {
  @override
  _ActivityFeedState createState() => _ActivityFeedState();
}

class _ActivityFeedState extends State<ActivityFeed> {
  Future futureFeed;
  dynamic feedData;

  /// Data lists
  Following feed;
  List<Gist> gists = [];
  List<Issue> issues = [];
  List<IssueComment> issueComments = [];
  List<PullRequest> pullRequests = [];
  List<StarredRepoEdge> stars = [];

  /// Master list
  List<ActivityFeedItem> activityFeed = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getFeedData();
  }

  Future<void> getFeedData() async {
    feedData = await Provider.of<GraphQLService>(context).activityFeed();

    // hack to ensure things don't happen too fast
    await Future.delayed(Duration(milliseconds: 250));
    setState(() => feed = Following.fromJson(feedData['user']['following']));
    buildActivityFeed();
  }

  void buildActivityFeed() {
    /// populate lists
    for (int uIndex = 0; uIndex < feed.userActivity.length; uIndex++) {
      gists += feed.userActivity[uIndex].gists.gist;
      issues += feed.userActivity[uIndex].issues.issues;
      issueComments += feed.userActivity[uIndex].issueComments.issueComments;
      pullRequests += feed.userActivity[uIndex].pullRequests.pullRequests;
      stars += feed.userActivity[uIndex].starredRepositories;
    }

    /// populate master list and sort by date/time
    activityFeed
      ..addAll(gists)
      ..addAll(issues)
      ..addAll(issueComments)
      ..addAll(pullRequests)
      ..addAll(stars)
      ..sort((e1, e2) => e2.createdAt.compareTo(e1.createdAt));
  }

  @override
  Widget build(BuildContext context) {
    if (activityFeed.isEmpty) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      /// build activity feed
      return Scrollbar(
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
      );
    }
  }
}
