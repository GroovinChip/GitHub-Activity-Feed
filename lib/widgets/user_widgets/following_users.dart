import 'package:flutter/material.dart';
import 'package:github_activity_feed/data/following_users.dart';
import 'package:github_activity_feed/services/graphql_service.dart';
import 'package:github_activity_feed/state/prefs_bloc.dart';
import 'package:github_activity_feed/widgets/user_widgets/user_card.dart';
import 'package:github_activity_feed/widgets/user_widgets/user_tile.dart';
import 'package:groovin_widgets/groovin_widgets.dart';
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
  Future _viewerFollowing;
  GraphQLService graphQLService;
  Following following;

  @override
  void initState() {
    super.initState();
    graphQLService = Provider.of<GraphQLService>(context, listen: false);
    following = Following(
      users: [],
    );
    _viewerFollowing = getFollowing();
  }

  Future<Following> getFollowing() async {
    graphQLService.getViewerFollowingPaginated(following.endCursor).then((value) {
      if (value.hasNextPage) {
        following.totalCount = value.totalCount;
        following.users.addAll(value.users);
        following.hasNextPage = value.hasNextPage;
        following.endCursor = value.endCursor;
        getFollowing();
      }
      following.totalCount = value.totalCount;
      following.users.addAll(value.users);
      following.hasNextPage = value.hasNextPage;
      following.endCursor = value.endCursor;
    });
    print(following.users.length);
    for (FollowingUser user in following.users) {
      FollowingUser user2;
      if (user2 == null) {
        user2 = user;
      } else {
        if (user2.login == user.login) {
          following.users.remove(user2);
        }
      }
    }
    print(following.users.length);
    return following;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: Provider.of<PrefsBloc>(context).cardOrTileSubject,
      builder: (context, isCardOrTile) {
        return FutureBuilder<Following>(
          future: getFollowing(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return ErrorWidget(snapshot.error);
            } else if (!snapshot.hasData && snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (!snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
              return Center(
                child: Text('No data'),
              );
            } else {
              //print(snapshot.data.totalCount);

              if (isCardOrTile.data) {
                return Scrollbar(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 1.1,
                    ),
                    itemCount: snapshot.data.users.length,
                    padding: EdgeInsets.all(8.0),
                    itemBuilder: (BuildContext context, int index) {
                      return UserCard(
                        user: snapshot.data.users[index],
                      );
                    },
                  ),
                );
              } else {
                return Scrollbar(
                  child: ListView.builder(
                    itemCount: snapshot.data.users.length,
                    padding: const EdgeInsets.all(8.0),
                    itemBuilder: (context, index) {
                      return UserTile(
                        user: snapshot.data.users[index],
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
