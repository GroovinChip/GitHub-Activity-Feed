import 'package:flutter/foundation.dart';
import 'package:github_activity_feed/utils/prettyJson.dart';
import 'package:simple_gql/simple_gql.dart';

/// This class handles GraphQL API calls to the GitHub v4 GraphQL endpoint
/// Some terminology:
/// - Viewer: the currently authenticated user
class GhGraphQLService {
  GhGraphQLService({
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
    return viewerBasicResponse.data;
  }

  /// This query returns more complex information related to the viewer
  Future<dynamic> getViewerComplex() async {
    // todo: error handling
    final GQLResponse viewerComplexResponse = await client.query(
      query: r'''
        query {
          viewer {
            login
            url
            avatarUrl
            bio
            bioHTML
            company
            email
            isViewer
            location
            status {
              message
              emoji
            }
            viewerCanFollow
            viewerIsFollowing
            websiteUrl
            
            starredRepositories(first: 100) {
              totalCount
            }
          }
        }
      ''',
      headers: {'Authorization': 'Bearer $token'},
    );
    return viewerComplexResponse.data;
  }

  /// This query returns a list of users that the viewer follows
  Future<dynamic> getViewerFollowing() async {
    // todo: error handling
    final GQLResponse viewerFollowingResponse = await client.query(
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
    return viewerFollowingResponse.data;
  }

  /// This query gets basic information related to a specified user
  Future<dynamic> getUserBasic(String userLogin) async {}

  /// This query returns more complex information related to a specified user
  Future<dynamic> getUserComplex(String userLogin) async {
    // todo: error handling
    final GQLResponse userComplexResponse = await client.query(
      query: r'''
        query ($userLogin:String!) {
          user: (login: "") {
            login
            url
            avatarUrl
            bio
            bioHTML
            company
            email
            isViewer
            location
            status {
              message
              emoji
            }
            viewerCanFollow
            viewerIsFollowing
            websiteUrl
            
            starredRepositories(first: 100) {
              totalCount
            }
          }
        }
      ''',
      headers: {'Authorization': 'Bearer $token'},
      variables: {
        'userLogin': userLogin,
      },
    );
    return userComplexResponse.data;
  }

  /// Get the main activity feed
  Future<dynamic> activityFeed() async {
    final GQLResponse response = await client.query(
      query: r'''
          query {
            viewer {
              following(last: 10) {
                nodes {
                  login
                  name
                  avatarUrl
                  issues(last: 10) {
                    nodes {
                      __typename
                      databaseId
                      title
                      author {
                        login
                        avatarUrl
                      }
                      repository {
                        nameWithOwner
                      }
                      createdAt
                    }
                  }
                  issueComments(last: 10) {
                    nodes {
                      __typename
                      databaseId
                      bodyText
                      createdAt
                      author {
                        login
                        avatarUrl
                      }
                      issue {
                        title
                        author {
                          login
                          avatarUrl
                        }
                        repository {
                          nameWithOwner
                        }
                        id
                        number
                      }
                    }
                  }
                  pullRequests(last: 10) {
                    nodes {
                      __typename
                      databaseId
                      title
                      createdAt
                      author {
                        login
                        avatarUrl
                      }
                      repository {
                        nameWithOwner
                        description
                      }
                    }
                  }
                }
              }
            }
          }
        ''',
      headers: {'Authorization': 'Bearer $token'},
    );
    return response.data;
  }

  //--- Mutations ---//

  /// Follow a user and return whether the operation was successful
  Future<bool> followUser(String userLogin) async {
    final GQLResponse followUserResponse = await client.mutation(
      mutation: r'''
        mutation FollowUser($input: FollowUserInput!) {
          followUser(inputData: $input) {
            clientMutationId
            user {
              viewerIsFollowing
            }
          }
        }
      ''',
      headers: {'Authorization': 'Bearer $token'},
      variables: {
        'FollowUserInput!': userLogin,
      },
    );
    return followUserResponse.data['user']['viewerIsFollowing'];
  }

  /// Unfollow a user and return whether the operation was successful
  Future<bool> unfollowUser(String userLogin) async {
    final GQLResponse unfollowUserResponse = await client.mutation(
      mutation: r'''
        mutation UnollowUser($input: UnfollowUserInput!) {
          unfollowUser(inputData: $input) {
            clientMutationId
            user {
              viewerIsFollowing
            }
          }
        }
      ''',
      headers: {'Authorization': 'Bearer $token'},
      variables: {
        'UnfollowUserInput!': userLogin,
      },
    );
    return unfollowUserResponse.data['user']['viewerIsFollowing'];
  }
}
