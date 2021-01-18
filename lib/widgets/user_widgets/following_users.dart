import 'package:flutter/material.dart';
import 'package:github_activity_feed/data/following_users.dart';
import 'package:github_activity_feed/services/graphql_service.dart';
import 'package:github_activity_feed/state/prefs_bloc.dart';
import 'package:github_activity_feed/widgets/feedback_on_error.dart';
import 'package:github_activity_feed/widgets/loading_spinner.dart';
import 'package:github_activity_feed/widgets/user_widgets/user_card.dart';
import 'package:github_activity_feed/widgets/user_widgets/user_tile.dart';
import 'package:provider/provider.dart';

class ViewerFollowingList extends StatefulWidget {
  ViewerFollowingList({
    Key key,
    this.emptyBuilder,
  }) : super(key: key);

  final WidgetBuilder emptyBuilder;

  @override
  _ViewerFollowingListState createState() => _ViewerFollowingListState();
}

class _ViewerFollowingListState extends State<ViewerFollowingList> {
  GraphQLService graphQLService;
  String cursor;
  List<FollowingUser> users = [];
  Future _followingUsers;

  @override
  void initState() {
    super.initState();
    graphQLService = Provider.of<GraphQLService>(context, listen: false);
    _followingUsers = getFollowing();
  }

  Future<List<FollowingUser>> getFollowing() async {
    // First query will execute with a null cursor. If query executes again,
    // it will have a cursor.
    final following = await graphQLService.getViewerFollowingPaginated(cursor);
    // Case 1. If user not following anyone or response is null, return empty list.
    if (following == null || following.users.isEmpty) {
      return users;
    }

    // Case 2. Last page of data/only one page of data. Add users to list, set cursor
    if (!following.hasNextPage && following.users.isNotEmpty) {
      setState(() {
        cursor = following.endCursor;
        users.addAll(following.users);
      });
    }

    // Case 3. First page of data/multiple pages of data. Add users to list,
    // store cursor, request more data.
    if (following.hasNextPage && following.users.isNotEmpty) {
      setState(() {
        cursor = following.endCursor;
        users.addAll(following.users);
      });
      getFollowing();
    }

    return users;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: Provider.of<PrefsBloc>(context).cardOrTileSubject,
      builder: (context, isCardOrTile) {
        return FutureBuilder<List<FollowingUser>>(
          future: _followingUsers,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return FeedbackOnError(
                message: snapshot.error.toString(),
              );
            } else if (!snapshot.hasData &&
                snapshot.connectionState == ConnectionState.waiting) {
              return LoadingSpinner();
            } else if (!snapshot.hasData &&
                snapshot.connectionState == ConnectionState.done) {
              return Center(
                child: Text('No data'),
              );
            } else {
              if (isCardOrTile.data) {
                return Scrollbar(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 1.1,
                    ),
                    itemCount: snapshot.data.length,
                    padding: EdgeInsets.all(8.0),
                    itemBuilder: (BuildContext context, int index) {
                      return UserCard(
                        user: snapshot.data[index],
                      );
                    },
                  ),
                );
              } else {
                return Scrollbar(
                  child: ListView.builder(
                    itemCount: snapshot.data.length,
                    padding: const EdgeInsets.all(8.0),
                    itemBuilder: (context, index) {
                      return UserTile(
                        user: snapshot.data[index],
                      );
                    },
                  ),
                );
              }
            }
          },
        );
      },
    );
  }
}
