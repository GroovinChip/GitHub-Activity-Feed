import 'package:flutter/material.dart';
import 'package:github_activity_feed/services/gh_gql_query_service.dart';
import 'package:github_activity_feed/widgets/feedback_on_error.dart';
import 'package:github_activity_feed/widgets/issue_card.dart';
import 'package:github_activity_feed/widgets/issue_comment_card.dart';
import 'package:github_activity_feed/widgets/pull_request_card.dart';
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
          final users = snapshot.data['user']['following']['nodes'];
          List<dynamic> issues = [];
          List<dynamic> issueComments = [];
          List<dynamic> pullRequests = [];
          List<dynamic> activityFeed = [];

          /// populate lists
          for (int uIndex = 0; uIndex < users.length; uIndex++) {
            issues += users[uIndex]['issues']['nodes'];
            issueComments += users[uIndex]['issueComments']['nodes'];
            pullRequests += users[uIndex]['pullRequests']['nodes'];
          }

          /// populate master list and sort by date/time
          activityFeed
            ..addAll(issues)
            ..addAll(issueComments)
            ..addAll(pullRequests)
            ..sort((e1, e2) => e2['createdAt'].compareTo(e1['createdAt']));

          /// build activity feed
          return Scrollbar(
            child: ListView.builder(
              itemCount: activityFeed.length,
              padding: const EdgeInsets.all(8.0),
              itemBuilder: (BuildContext context, int index) {
                switch (activityFeed[index]['__typename']) {
                  case 'Issue':
                    return IssueCard(issue: activityFeed[index]);
                  case 'IssueComment':
                    return IssueCommentCard(comment: activityFeed[index]);
                  case 'PullRequest':
                    return PullRequestCard(pullRequest: activityFeed[index]);
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
