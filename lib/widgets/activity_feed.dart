import 'package:flutter/material.dart';
import 'package:github_activity_feed/data/activity_feed_models.dart';
import 'package:github_activity_feed/data/gist.dart';
import 'package:github_activity_feed/services/gh_gql_query_service.dart';
import 'package:github_activity_feed/widgets/feedback_on_error.dart';
import 'package:github_activity_feed/widgets/gist_card.dart';
import 'package:github_activity_feed/widgets/issue_card.dart';
import 'package:github_activity_feed/widgets/issue_comment_card.dart';
import 'package:github_activity_feed/widgets/pull_request_card.dart';
import 'package:github_activity_feed/widgets/star_card.dart';
import 'package:provider/provider.dart';

class ActivityFeed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ghGraphQLService = Provider.of<GhGraphQLService>(context, listen: false);
    return FutureBuilder<dynamic>(
      future: ghGraphQLService.activityFeed(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData && snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return FeedbackOnError(message: snapshot.error.toString());
        } else {
          /// lists of data
          final Following feed = Following.fromJson(snapshot.data['user']['following']);
          List<Gist> gists = [];
          List<Issue> issues = [];
          List<IssueComment> issueComments = [];
          List<PullRequest> pullRequests = [];
          List<SrEdge> stars = [];

          // todo: turn into Map so that we get the name of the user who starred. Then turn back into list.
          List<dynamic> activityFeed = [];

          /// populate lists
          for (int uIndex = 0; uIndex < feed.userActivity.length; uIndex++) {
            gists += feed.userActivity[uIndex].gists.gist;
            issues += feed.userActivity[uIndex].issues.issues;
            issueComments += feed.userActivity[uIndex].issueComments.issueComments;
            pullRequests += feed.userActivity[uIndex].pullRequests.pullRequests;
            stars += feed.userActivity[uIndex].starredRepositories.srEdges;
          }

          /// populate master list and sort by date/time
          activityFeed
            ..addAll(gists)
            ..addAll(issues)
            ..addAll(issueComments)
            ..addAll(pullRequests)
            ..addAll(stars)
            ..sort((e1, e2) => e2.createdAt.compareTo(e1.createdAt));

          /// build activity feed
          return Scrollbar(
            child: ListView.builder(
              itemCount: activityFeed.length,
              padding: const EdgeInsets.all(8.0),
              itemBuilder: (BuildContext context, int index) {
                switch (activityFeed[index].sTypename) {
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
                      star: activityFeed[index].star,
                      starredAt: activityFeed[index].createdAt,
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
