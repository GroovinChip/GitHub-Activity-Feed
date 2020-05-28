import 'package:flutter/material.dart';
import 'package:github_activity_feed/services/gh_gql_query_service.dart';
import 'package:github_activity_feed/widgets/feedback_on_error.dart';
import 'package:github_activity_feed/widgets/issue_comment_card.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

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

          return ListView.builder(
            itemCount: activityFeed.length,
            itemBuilder: (BuildContext context, int index) {
              switch (activityFeed[index]['__typename']) {
                case 'Issue':
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
                            '${activityFeed[index]['author']['login']} opened',
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
                                  text: '${activityFeed[index]['repository']['nameWithOwner']} ',
                                ),

                                /// this is here for optional styling
                                TextSpan(text: '#${activityFeed[index]['number']}'),
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
                            activityFeed[index]['bodyText'] ?? 'No description',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 14),
                          ),
                        )
                      ],
                    ),
                  );
                case 'IssueComment':
                  return IssueCommentCard(comment: activityFeed[index]);
                case 'PullRequest':
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
                            '${activityFeed[index]['author']['login']} opened pull request',
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
                                  text: '${activityFeed[index]['repository']['nameWithOwner']} ',
                                ),

                                /// this is here for optional styling
                                TextSpan(text: '#${activityFeed[index]['number']}'),
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
                            activityFeed[index]['bodyText'] ?? 'No description',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 14),
                          ),
                        )
                      ],
                    ),
                  );
                default:
                  return Container();
              }
            },
          );
        }
      },
    );
  }
}
