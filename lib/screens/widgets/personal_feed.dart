import 'package:flutter/material.dart';
import 'package:github/github.dart';
import 'package:github/hooks.dart';
import 'package:github_activity_feed/app/provided.dart';
import 'package:github_activity_feed/services/extensions.dart';

class PersonalFeed extends StatefulWidget {
  PersonalFeed({Key key}) : super(key: key);

  @override
  _PersonalFeedState createState() => _PersonalFeedState();
}

class _PersonalFeedState extends State<PersonalFeed> with ProvidedState {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Event>>(
      stream: github.github.activity.listEventsPerformedByUser(user.login).toList().asStream(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        } else {
          final events = snapshot?.data;
          return ListView.builder(
            padding: const EdgeInsets.only(left: 8, right: 8),
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              Widget eventWidget;

              eventWidget = _determineEvent(event, eventWidget, context);

              return eventWidget != null
                  ? Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: InkWell(
                        customBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        onTap: () {},
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(user.avatarUrl),
                              ),
                              title: eventWidget,
                            ),
                          ],
                        ),
                      ),
                    )
                  : Container();
            },
          );
        }
      },
    );
  }

  Widget _determineEvent(Event event, Widget eventWidget, BuildContext context) {
    switch (event.type) {
      case 'PushEvent':
        eventWidget = _buildPush(event, eventWidget);
        break;
      case 'IssueCommentEvent':
        eventWidget = _buildIssueComment(
          event,
          eventWidget,
          context,
        );
        break;
      case 'IssuesEvent':
        eventWidget = _buildIssue(event, eventWidget);
        break;
      case 'CreateEvent':
        eventWidget = _buildCreateTag(event, eventWidget);
        break;
      case 'WatchEvent':
        eventWidget = _buildStar(eventWidget, event);
        break;
      default:
        break;
    }
    return eventWidget;
  }

  Widget _buildStar(Widget eventWidget, Event event) {
    eventWidget = RichText(
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(text: user.login),
          TextSpan(
            text: ' starred',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(text: ' starred ${event.repo.name}'),
        ]
      ),
    );
    return eventWidget;
  }

  Widget _buildPush(Event event, Widget eventWidget) {
    Map<String, dynamic> pushEvent = event.payload;
    int size = pushEvent['size'];
    eventWidget = RichText(
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
            text: '${user.login} ',
          ),
          TextSpan(
            text: 'pushed $size ${size > 1 ? 'commits' : 'commit'} ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: 'to ${event.repo.name}/${pushEvent['ref']}',
          ),
        ],
      ),
    );
    return eventWidget;
  }

  Widget _buildCreateTag(Event event, Widget eventWidget) {
    if (event.payload['ref_type'] == 'tag') {
      eventWidget = RichText(
        text: TextSpan(
          children: <TextSpan>[
            TextSpan(
              text: '${user.login} ',
            ),
            TextSpan(
              text: 'created ${event.payload['ref_type']} ${event.payload['ref']}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(text: ' at ${event.repo.name}'),
          ],
        ),
      );
    }
    return eventWidget;
  }

  Widget _buildIssue(Event event, Widget eventWidget) {
    IssueEvent issueEvent = IssueEvent.fromJson(event.payload);
    eventWidget = RichText(
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
            text: '${issueEvent.issue.user.login} ',
          ),
          TextSpan(
            text: '${issueEvent.action} issue #${issueEvent.issue.number}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(text: ' at ${event.repo.name}'),
        ],
      ),
    );
    return eventWidget;
  }

  Widget _buildIssueComment(Event event, Widget eventWidget, BuildContext context) {
    IssueCommentEvent issueCommentEvent = IssueCommentEvent.fromJson(event.payload);
    String issueCommentAction;
    switch (issueCommentEvent.action) {
      case 'created':
        issueCommentAction = 'commented on';
        break;
      default:
        issueCommentAction = issueCommentEvent.action;
        break;
    }
    eventWidget = RichText(
      text: TextSpan(
        style: TextStyle(
          color: context.brightness == Brightness.light ? Colors.black : Color(0xffE6F4F1),
        ),
        children: <TextSpan>[
          TextSpan(text: '${issueCommentEvent.comment.user.login} '),
          TextSpan(
            text: '$issueCommentAction issue #${issueCommentEvent.issue.number}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(text: ' at ${event.repo.name}'),
        ],
      ),
    );
    return eventWidget;
  }
}
