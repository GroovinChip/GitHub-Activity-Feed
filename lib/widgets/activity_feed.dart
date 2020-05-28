import 'package:flutter/material.dart';
import 'package:github/github.dart';
import 'package:github/hooks.dart';
import 'package:github_activity_feed/screens/commit_list_screen.dart';
import 'package:github_activity_feed/screens/issue_screen.dart';
import 'package:github_activity_feed/screens/pull_request_screen.dart';
import 'package:github_activity_feed/screens/repository_screen.dart';
import 'package:github_activity_feed/screens/user_overview.dart';
import 'package:github_activity_feed/services/gh_gql_query_service.dart';
import 'package:github_activity_feed/utils/navigation_util.dart';
import 'package:github_activity_feed/utils/prettyJson.dart';
import 'package:github_activity_feed/widgets/event_card.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;
import 'package:timeago/timeago.dart' as timeago;

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
                  return Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          /// user avatar
                          leading: GestureDetector(
                            onTap: () {},
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(
                                activityFeed[index]['author']['avatarUrl'],
                              ),
                            ),
                          ),
                          /// user with action
                          title: Text(
                            '${activityFeed[index]['author']['login']} commented',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onBackground,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          /// repository with issue number
                          subtitle: RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                  text:
                                      '${activityFeed[index]['issue']['repository']['nameWithOwner']} ',
                                ),

                                /// this is here for optional styling
                                TextSpan(text: '#${activityFeed[index]['issue']['number']}'),
                              ],
                            ),
                          ),
                          /// fuzzy timestamp
                          trailing: Text(timeago
                              .format(DateTime.parse(activityFeed[index]['createdAt']),
                                  locale: 'en_short')
                              .replaceAll(' ', '')),
                        ),
                        /// issue body text preview
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          child: Text(
                            activityFeed[index]['bodyText'],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14
                            ),
                          ),
                        )
                      ],
                    ),
                  );
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
