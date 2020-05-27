import 'package:flutter/foundation.dart';
import 'package:github_activity_feed/utils/prettyJson.dart';
import 'package:simple_gql/simple_gql.dart';

/// This class handles GraphQL API calls to the GitHub v4 GraphQL endpoint
/// Some terminology:
/// - Viewer: the currently authenticated user
class GHQueryService {
  GHQueryService({
    @required this.token,
  });

  /// Our GQL Client. We will make our api calls using this client.
  final GQLClient client = GQLClient(url: 'https://api.github.com/graphql');

  /// Our auth token. Required to make calls against the GitHub v4 API.
  final String token;

  //--- Queries ---//

  /// This query gets basic information related to the viewer
  Future<dynamic> getViewerBasic() async {
    // todo: error handling
    final GQLResponse viewerBasicResponse = await client.query(
      query: r'''
        query {
          viewer {
            login
            avatarUrl
          }
        }
      ''',
      headers: {'Authorization': 'Bearer $token'},
    );
    print('API CALL: Viewer Basic:');
    printPrettyJson(viewerBasicResponse.data);
    return viewerBasicResponse.data;
  }

  /// This query returns more complex information related to the viewer
  Future<dynamic> getViewerComplex() async {}

  /// This query returns a list of users that the viewer follows
  Future<dynamic> getViewerFollowing() async {
    // todo: error handling
    final GQLResponse viewerBasicResponse = await client.query(
      query: r'''
        query {
          viewer {
            following (first: 100) {
              totalCount
              users: nodes {
                login
                avatarUrl
              }
            }
          }
        }
      ''',
      headers: {'Authorization': 'Bearer $token'},
    );
    print('API CALL: Viewer Following:');
    printPrettyJson(viewerBasicResponse.data);
    return viewerBasicResponse.data;
  }

  /// This query gets basic information related to a specified user
  Future<dynamic> getUserBasic(String userLogin) async {}

  /// This query returns more complex information related to a specified user
  Future<dynamic> getUserComplex(String userLogin) async {}
}
