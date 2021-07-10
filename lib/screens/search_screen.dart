import 'dart:async';

import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:flutter/material.dart';
import 'package:github/github.dart' hide SearchResults;
import 'package:github_activity_feed/data/search_results.dart';
import 'package:github_activity_feed/services/graphql_service.dart';
import 'package:github_activity_feed/utils/extensions.dart';
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

  List<UserFromSearch> searchResults = [];

  @override
  String get searchFieldLabel => 'Search users';

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
      primaryColor: theme.appBarTheme.color,
      primaryIconTheme: IconThemeData(
        color: context.isDarkTheme ? Colors.white : Colors.black,
      ),
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
          searchResults.clear();
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
    if (showCardsOrTiles) {
      return Scrollbar(
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 1.1,
          ),
          padding: EdgeInsets.all(8.0),
          itemCount: searchResults.length,
          itemBuilder: (BuildContext context, int index) {
            return UserCard(
              user: searchResults[index],
            );
          },
        ),
      );
    } else {
      return Scrollbar(
        child: ListView.builder(
          padding: EdgeInsets.all(8.0),
          itemCount: searchResults.length,
          itemBuilder: (BuildContext context, int index) {
            if (searchResults[index].name == null &&
                searchResults[index].login == null) {
              return const SizedBox.shrink();
            }
            return UserTile(
              user: searchResults[index],
            );
          },
        ),
      );
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        final graphQlService = Provider.of<GraphQLService>(context);
        final debouncer = Debouncer<String>(Duration(milliseconds: 100));

        Future<List<UserFromSearch>> search() async {
          debouncer.value = query;
          if (debouncer.value == null || debouncer.value.isEmpty) {
            return [];
          } else {
            return graphQlService.searchUsers(await debouncer.nextValue);
          }
        }

        return FutureBuilder<List<UserFromSearch>>(
          future: search(),
          builder: (context, snapshot) {
            if (!snapshot.hasData ||
                snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: context.theme.primaryColor,
                ),
              );
            } else if (snapshot.hasError) {
              return FeedbackOnError(
                message: snapshot.error.toString(),
              );
            } else if (snapshot.data?.length == 0) {
              return Center(
                child: Text('No results'),
              );
            } else {
              searchResults = snapshot.data;
              if (showCardsOrTiles) {
                return Scrollbar(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 1.1,
                    ),
                    padding: EdgeInsets.all(8.0),
                    itemCount: snapshot.data.length,
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
                    padding: EdgeInsets.all(8.0),
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (snapshot.data[index].name == null &&
                          snapshot.data[index].login == null) {
                        return const SizedBox.shrink();
                      }
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
