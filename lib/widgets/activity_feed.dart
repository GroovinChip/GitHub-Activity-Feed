import 'package:flutter/material.dart';
import 'package:github/github.dart';
import 'package:github/hooks.dart';
import 'package:github_activity_feed/screens/commit_list_screen.dart';
import 'package:github_activity_feed/screens/issue_screen.dart';
import 'package:github_activity_feed/screens/pull_request_screen.dart';
import 'package:github_activity_feed/screens/repository_screen.dart';
import 'package:github_activity_feed/services/gh_gql_query_service.dart';
import 'package:github_activity_feed/widgets/issue_comment_event_card.dart';
import 'package:provider/provider.dart';

class ActivityFeed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ghGraphQLService = Provider.of<GhGraphQLService>(context, listen: false);
    return FutureBuilder<dynamic>(
      future: ghGraphQLService.activityFeed(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          /// lists of data
          final users = snapshot.data['viewer']['following']['nodes'];
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

          return ListView.builder(
            itemCount: activityFeed.length,
            itemBuilder: (BuildContext context, int index) {
              switch (activityFeed[index]['__typename']) {
                case 'Issue':
                  return Container();
                case 'IssueComment':
                  return IssueCommentEventCard(comment: activityFeed[index]);
                case 'PullRequest':
                  return Container();
                default:
                  return Container();
              }
            },
          );
        }
      },
    );
  }

  void _navigateToIssue(BuildContext context, Event event) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => IssueScreen(event: event),
      ),
    );
  }

  void _navigateToPullRequest(Event event, BuildContext context) {
    PullRequestEvent _prEvent = PullRequestEvent.fromJson(event.payload);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PullRequestScreen(
          event: event,
          pullRequestEvent: _prEvent,
        ),
      ),
    );
  }

  void _navigateToCommits(Event event, BuildContext context) {
    List<GitCommit> commits = [];
    for (dynamic commit in event.payload['commits']) {
      commits.add(GitCommit.fromJson(commit));
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CommitListScreen(
          committedBy: event.actor,
          repoName: event.repo.name,
          commits: commits,
          fromEventType: event.type,
        ),
      ),
    );
  }

  void _navigateToRepo(BuildContext context, Event event) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => RepositoryScreen(event: event),
      ),
    );
  }
}
