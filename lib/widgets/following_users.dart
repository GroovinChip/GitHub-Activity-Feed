import 'package:flutter/material.dart';
import 'package:github_activity_feed/data/following_users.dart';
import 'package:github_activity_feed/services/gh_gql_query_service.dart';
import 'package:github_activity_feed/widgets/user_card.dart';
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
  GhGraphQLService ghGraphQLService;

  @override
  void initState() {
    super.initState();
    ghGraphQLService = Provider.of<GhGraphQLService>(context, listen: false);

    /// prevent FutureBuilder from rebuilding on setState() calls
    _viewerFollowing = ghGraphQLService.getViewerFollowing();
  }

  @override
  Widget build(BuildContext context) {
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
            child: ListView.builder(
              itemCount: viewerFollowing.following.users.length,
              padding: const EdgeInsets.all(8.0),
              itemBuilder: (context, index) {
                final FollowingUser user = viewerFollowing.following.users[index];
                return UserCard(
                  avatarUrl: user.avatarUrl,
                  id: user.id.toString(),
                  login: user.login,
                  name: user.name,
                  url: user.url,
                );
              },
            ),
          );
        }
      },
    );
  }
}
