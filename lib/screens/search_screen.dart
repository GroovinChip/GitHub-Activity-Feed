import 'package:flutter/material.dart';
import 'package:github/github.dart';
import 'package:github_activity_feed/services/gh_gql_query_service.dart';
import 'package:github_activity_feed/widgets/feedback_on_error.dart';
import 'package:github_activity_feed/widgets/user_card.dart';
import 'package:provider/provider.dart';

class SearchScreen extends SearchDelegate {
  SearchScreen({
    @required this.gitHub,
  });

  final GitHub gitHub;
  List<dynamic> users = [];

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
        return UserCard(
          user: users[index],
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: Provider.of<GhGraphQLService>(context).searchUsers(query),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData && snapshot.connectionState == ConnectionState.waiting) {
          /// loading
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          /// Error
          return FeedbackOnError(
            message: snapshot.error.toString(),
          );
        } else if (snapshot.data['search']['edges'].length == 0) {
          /// No results
          return Center(
            child: Text('No results'),
          );
        } else {
          /// results
          users = snapshot.data['search']['edges'];
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (BuildContext context, int index) {
              return UserCard(
                user: users[index],
              );
            },
          );
        }
      },
    );
  }
}
