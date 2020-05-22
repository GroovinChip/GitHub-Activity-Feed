import 'package:flutter/material.dart';
import 'package:github/github.dart';
import 'package:github_activity_feed/screens/user_overview.dart';
import 'package:github_activity_feed/utils/navigation_util.dart';

class SearchScreen extends SearchDelegate {
  SearchScreen({
    @required this.gitHub,
  });

  final GitHub gitHub;
  List<User> users = [];

  @override
  String get searchFieldLabel => 'Search users';

  @override
  ThemeData appBarTheme(BuildContext context) {
    assert(context != null);
    final ThemeData theme = Theme.of(context);
    assert(theme != null);
    return theme;
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
          users.clear();
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return BackButton();
  }

  @override
  Widget buildResults(BuildContext context) {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(users[index].avatarUrl),
          ),
          onTap: () => navigateToScreen(
            context,
            UserOverview(
              user: users[index],
            ),
          ),
          title: Text(users[index].login),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<List<User>>(
      future: gitHub.search.users(query).toList(),
      builder: (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error),
          );
        } else if (snapshot.data.length == 0) {
          return Center(
            child: Text('No results'),
          );
        } else {
          users = snapshot.data;
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(snapshot.data[index].avatarUrl),
                ),
                onTap: () => navigateToScreen(
                  context,
                  UserOverview(
                    user: snapshot.data[index],
                  ),
                ),
                title: Text(snapshot.data[index].login),
              );
            },
          );
        }
      },
    );
  }
}
