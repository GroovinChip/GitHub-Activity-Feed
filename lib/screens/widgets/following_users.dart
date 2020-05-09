import 'package:flutter/material.dart';
import 'package:github/github.dart';
import 'package:github_activity_feed/app/provided.dart';

class FollowingUsers extends StatefulWidget {
  FollowingUsers({
    Key key,
    @required this.users,
  }) : super(key: key);

  final List<User> users;

  @override
  _FollowingUsersState createState() => _FollowingUsersState();
}

class _FollowingUsersState extends State<FollowingUsers> with ProvidedState {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.users.length,
      itemBuilder: (context, index) {
        return Material(
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(widget.users[index].avatarUrl),
            ),
            title: Text(
              widget.users[index].login,
              style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
            ),
          ),
        );
      },
    );
  }
}
