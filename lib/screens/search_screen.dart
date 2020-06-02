import 'package:flutter/material.dart';
import 'package:github/github.dart' hide SearchResults;
import 'package:github_activity_feed/data/search_results.dart';
import 'package:github_activity_feed/services/gh_gql_query_service.dart';
import 'package:github_activity_feed/widgets/feedback_on_error.dart';
import 'package:github_activity_feed/widgets/user_widgets/user_card.dart';
import 'package:github_activity_feed/widgets/user_widgets/user_tile.dart';
import 'package:provider/provider.dart';

class SearchScreen extends SearchDelegate {
  SearchScreen({
    @required this.gitHub,
    @required this.showCardsOrTiles,
  });

  final GitHub gitHub;
  final bool showCardsOrTiles;

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
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1.1,
      ),
      padding: EdgeInsets.all(8.0),
      itemCount: searchResults.edges.length,
      itemBuilder: (BuildContext context, int index) {
        return UserCard(
          user: searchResults.edges[index].node,
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
          if (showCardsOrTiles) {
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 1.1,
              ),
              padding: EdgeInsets.all(8.0),
              itemCount: searchResults.edges.length,
              itemBuilder: (BuildContext context, int index) {
                return UserCard(
                  user: searchResults.edges[index].node,
                );
              },
            );
          } else {
            return ListView.builder(
              padding: EdgeInsets.all(8.0),
              itemCount: searchResults.edges.length,
              itemBuilder: (BuildContext context, int index) {
                return UserTile(
                  user: searchResults.edges[index].node,
                );
              },
            );
          }
        }
      },
    );
  }
}
