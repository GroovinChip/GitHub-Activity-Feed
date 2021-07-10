import 'package:flutter/material.dart';
import 'package:github_activity_feed/app/provided.dart';
import 'package:github/github.dart';
import 'package:github_activity_feed/widgets/loading_spinner.dart';
import 'package:github_activity_feed/widgets/user_widgets/user_avatar.dart';
import 'package:github_activity_feed/services/github_service.dart';

class UserFeedScreen extends StatefulWidget {
  const UserFeedScreen({
    Key key,
    @required this.username,
  }) : super(key: key);

  final String username;

  @override
  _UserFeedScreenState createState() => _UserFeedScreenState();
}

class _UserFeedScreenState extends State<UserFeedScreen> with ProvidedState {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.username}\'s feed'),
      ),
      body: FutureBuilder<List<Event>>(
        future:
            github.activity.listEventsPerformedByUser(widget.username).toList(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: LoadingSpinner(),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                final event = snapshot.data[index];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            UserAvatar(
                              width: 44,
                              height: 44,
                              avatarUrl: event.actor.avatarUrl,
                              userUrl: event.actor.htmlUrl,
                            ),
                            const SizedBox(width: 8.0),
                            Expanded(
                              child: Text(event.action),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
