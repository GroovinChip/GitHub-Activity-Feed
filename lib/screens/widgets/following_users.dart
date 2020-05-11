import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:github/github.dart';
import 'package:github_activity_feed/app/provided.dart';
import 'package:github_activity_feed/screens/mobile/mobile_profile.dart';
import 'package:github_activity_feed/screens/widgets/user_list_tile.dart';

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
    return Scrollbar(
      child: ListView.builder(
        itemCount: widget.users.length,
        itemBuilder: (context, index) {
          return OpenContainer(
            closedColor: Theme.of(context).canvasColor,
            closedElevation: 0,
            closedBuilder: (BuildContext context, action) {
              return UserListTile(user: widget.users[index]);
            },
            openBuilder: (BuildContext context, action) {
              return MobileProfile(user: widget.users[index]);
            },
          );
        },
      ),
    );
  }
}
