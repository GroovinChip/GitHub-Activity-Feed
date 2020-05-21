import 'package:flutter/material.dart';
import 'package:github/github.dart';
import 'package:github_activity_feed/widgets/user_list_tile.dart';

class UserFollows extends StatefulWidget {
  UserFollows({
    Key key,
    @required this.user,
    @required this.userFollowers,
  }) : super(key: key);

  final User user;
  final List<User> userFollowers;

  @override
  _UserFollowsState createState() => _UserFollowsState();
}

class _UserFollowsState extends State<UserFollows> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Followers of ${widget.user.login}'),
      ),
      body: Scrollbar(
        child: ListView.builder(
          itemCount: widget.userFollowers.length,
          itemBuilder: (context, index) {
            final user = widget.userFollowers[index];
            return UserListTile(user: user);
          },
        ),
      ),
    );
  }
}
