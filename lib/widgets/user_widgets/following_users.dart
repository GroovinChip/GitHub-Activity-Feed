import 'package:flutter/material.dart';
import 'package:github_activity_feed/data/following_users.dart';
import 'package:github_activity_feed/services/graphql_service.dart';
import 'package:github_activity_feed/state/prefs_bloc.dart';
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
  Future _viewerFollowing;
  GraphQLService graphQLService;

  @override
  void initState() {
    super.initState();
    graphQLService = Provider.of<GraphQLService>(context, listen: false);

    /// prevent FutureBuilder from rebuilding on setState() calls
    _viewerFollowing = graphQLService.getViewerFollowing();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: Provider.of<PrefsBloc>(context).cardOrTileSubject,
      builder: (BuildContext context, AsyncSnapshot<bool> isCardOrTile) {
        return FutureBuilder<dynamic>(
          future: _viewerFollowing,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              return ErrorWidget(snapshot.error);
            } else if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.data.isEmpty && widget.emptyBuilder != null) {
              return widget.emptyBuilder(context);
            } else {
              FollowingUsers viewerFollowing = FollowingUsers.fromJson(snapshot.data['user']);
              return Scrollbar(
                child: isCardOrTile.data == true
                    ? GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: 1.1,
                        ),
                        itemCount: viewerFollowing.following.users.length,
                        padding: EdgeInsets.all(8.0),
                        itemBuilder: (BuildContext context, int index) {
                          final FollowingUser user = viewerFollowing.following.users[index];
                          return UserCard(
                            user: user,
                          );
                        },
                      )
                    : ListView.builder(
                        itemCount: viewerFollowing.following.users.length,
                        padding: const EdgeInsets.all(8.0),
                        itemBuilder: (context, index) {
                          final FollowingUser user = viewerFollowing.following.users[index];
                          return UserTile(
                            user: user,
                          );
                        },
                      ),
              );
            }
          },
        );
      },
    );
  }
}
