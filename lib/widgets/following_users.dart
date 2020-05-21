import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:github/github.dart';
import 'package:github_activity_feed/screens/user_overview.dart';
import 'package:github_activity_feed/widgets/user_list_tile.dart';

class FollowingUsers extends StatelessWidget {
  FollowingUsers({
    Key key,
    @required this.users,
    this.emptyBuilder,
  }) : super(key: key);

  final Stream<List<User>> users;
  final WidgetBuilder emptyBuilder;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<User>>(
        stream: users,
        builder: (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
          if (snapshot.hasError) {
            return ErrorWidget(snapshot.error);
          }
          else if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          else if(snapshot.data.isEmpty && emptyBuilder != null) {
            return emptyBuilder(context);
          }
        return Scrollbar(
          child: ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              return OpenContainer(
                closedColor: Theme.of(context).canvasColor,
                closedElevation: 0,
                closedBuilder: (BuildContext context, action) {
                  return UserListTile(user: snapshot.data[index]);
                },
                openBuilder: (BuildContext context, action) {
                  return UserOverview(user: snapshot.data[index]);
                },
              );
            },
          ),
        );
      }
    );
  }
}
