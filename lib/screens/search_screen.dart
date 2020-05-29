import 'package:flutter/material.dart';
import 'package:github/github.dart' hide SearchResults;
import 'package:github_activity_feed/data/search_results.dart';
import 'package:github_activity_feed/services/gh_gql_query_service.dart';
import 'package:github_activity_feed/widgets/feedback_on_error.dart';
import 'package:github_activity_feed/widgets/user_card.dart';
import 'package:provider/provider.dart';

class SearchScreen extends SearchDelegate {
  SearchScreen({
    @required this.gitHub,
  });

  final GitHub gitHub;
  SearchResults searchResults;

  @override
  String get searchFieldLabel => 'Search users';

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
      primaryColor: theme.appBarTheme.color,
      primaryIconTheme: theme.appBarTheme.iconTheme,
      primaryColorBrightness: theme.appBarTheme.brightness,
      primaryTextTheme: theme.appBarTheme.textTheme,
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
          searchResults.edges.clear();
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
      itemCount: searchResults.edges.length,
      itemBuilder: (BuildContext context, int index) {
        return UserCard(
          avatarUrl: searchResults.edges[index].node.avatarUrl,
          id: searchResults.edges[index].node.id,
          login: searchResults.edges[index].node.login,
          name: searchResults.edges[index].node.name,
          url: searchResults.edges[index].node.url,
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
          searchResults = SearchResults.fromJson(snapshot.data['search']);
          return ListView.builder(
            itemCount: searchResults.edges.length,
            itemBuilder: (BuildContext context, int index) {
              return UserCard(
                avatarUrl: searchResults.edges[index].node.avatarUrl,
                id: searchResults.edges[index].node.id,
                login: searchResults.edges[index].node.login,
                name: searchResults.edges[index].node.name,
                url: searchResults.edges[index].node.url,
              );
            },
          );
        }
      },
    );
  }
}
