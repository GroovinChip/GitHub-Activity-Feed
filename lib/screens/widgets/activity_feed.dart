import 'dart:convert';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:github/github.dart';
import 'package:github/hooks.dart';
import 'package:github_activity_feed/screens/commit_list_screen.dart';
import 'package:github_activity_feed/screens/issue_screen.dart';
import 'package:github_activity_feed/screens/pull_request_screen.dart';
import 'package:github_activity_feed/screens/repository_screen.dart';
import 'package:github_activity_feed/screens/widgets/event_card.dart';
import 'package:github_activity_feed/utils/prettyJson.dart';

class ActivityFeed extends StatelessWidget {
  ActivityFeed({
    Key key,
    @required this.events,
    this.emptyBuilder,
  }) : super(key: key);

  final Stream<List<Event>> events;
  final WidgetBuilder emptyBuilder;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Event>>(
      stream: events,
      builder: (BuildContext context, AsyncSnapshot<List<Event>> snapshot) {
        if (snapshot.hasError) {
          return ErrorWidget(snapshot.error);
        } else if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.data.isEmpty && emptyBuilder != null) {
          return emptyBuilder(context);
        }
        return Scrollbar(
          child: ListView.builder(
            itemCount: snapshot.data.length,
            padding: const EdgeInsets.only(left: 8, right: 8, top: 4),
            itemBuilder: (BuildContext context, int index) {
              Event event = snapshot.data[index];
              print(event.type);
              return GestureDetector(
                onTap: () {
                  if (event.type == 'IssuesEvent' || event.type == 'IssueCommentEvent') {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => IssueScreen(event: event),
                      ),
                    );
                  } else if (event.type == 'PullRequestEvent') {
                    PullRequestEvent _prEvent = PullRequestEvent.fromJson(event.payload);
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => PullRequestScreen(
                          event: event,
                          pullRequestEvent: _prEvent,
                        ),
                      ),
                    );
                  } else if (event.type == 'PushEvent') {
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
                        ),
                      ),
                    );
                  } else {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => RepositoryScreen(event: event),
                      ),
                    );
                  }
                },
                child: event.type != 'MemberEvent' ? EventCard(event: event) : Container(),
              );
              return OpenContainer(
                closedColor: Theme.of(context).canvasColor,
                closedBuilder: (BuildContext context, action) {
                  return EventCard(event: event);
                },
                openBuilder: (BuildContext context, action) {
                  if (event.type == 'IssuesEvent' || event.type == 'IssueCommentEvent') {
                    return IssueScreen(
                      event: event,
                    );
                  } else {
                    return RepositoryScreen(
                      // todo: pass repo slug in here?
                      event: event,
                    );
                  }
                },
              );
            },
          ),
        );
      },
    );
  }
}
