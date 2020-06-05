import 'package:flutter/foundation.dart';
import 'package:simple_gql/simple_gql.dart';

/// This class handles GraphQL API calls to the GitHub v4 GraphQL endpoint
/// Some terminology:
/// - Viewer: the currently authenticated user
class GraphQLService {
  GraphQLService({
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
          user: viewer {
            login
            avatarUrl
          }
        }
      ''',
      headers: {'Authorization': 'Bearer $token'},
    );
    return viewerBasicResponse.data;
  }

  Future<dynamic> isViewerFollowingUser(String userLogin) async {
    GQLResponse isViewerFollowingUserResponse;
    // todo: error handling
    isViewerFollowingUserResponse = await client.query(
      query: r'''
        query ($userLogin: String!) {
          user (login: $userLogin) {
            viewerIsFollowing
          }
        }
      ''',
      headers: {'Authorization': 'Bearer $token'},
      variables: {'userLogin': userLogin},
    );
    return isViewerFollowingUserResponse.data;
  }

  /// This query returns more complex information related to the viewer
  Future<dynamic> getViewerComplex() async {
    // todo: error handling
    final GQLResponse viewerComplexResponse = await client.query(
      query: r'''
        query {
          user: viewer {
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
            name
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
          user: viewer {
            following (first: 100) {
              totalCount
              users: nodes {
                id
                login
                url
                avatarUrl
                createdAt
                viewerIsFollowing
                bio
                location
                name
                email
                company
                status {
                  emoji
                  message
                }
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
  Future<dynamic> getUserBasic(String userLogin) async {
    GQLResponse userBasicResponse;
    try {
      userBasicResponse = await client.query(
        query: r'''
        query ($userLogin: String!) {
          user (login: $userLogin) {
            login
            avatarUrl
          }
        }
      ''',
        headers: {'Authorization': 'Bearer $token'},
        variables: {'userLogin': userLogin},
      );
    } on GQLError catch (e) {
      print(e);
    } catch (error, stackTrace) {
      print('$error\n$stackTrace');
    }
    return userBasicResponse.data;
  }

  /// This query returns more complex information related to a specified user
  Future<dynamic> getUserComplex(String userLogin) async {
    // todo: error handling
    final GQLResponse userComplexResponse = await client.query(
      query: r'''
        query ($userLogin: String!) {
          user (login: $userLogin) {
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
  /// todo: pagination
  Future<dynamic> activityFeed() async {
    final GQLResponse response = await client.query(
      query: r'''
          {
            user: viewer {
              following(last: 10) {
                user: nodes {
                  login
                  avatarUrl
                  url
                  gists(last: 10, privacy: PUBLIC) {
                    gist: nodes {
                      __typename
                      description
                      createdAt
                      comments {
                        totalCount
                      }
                      forks {
                        totalCount
                      }
                      stargazers {
                        totalCount
                      }
                      files {
                        name
                      }
                      owner {
                        login
                        avatarUrl
                        url
                      }
                      url
                    }
                  }
                  issues(last: 10) {
                    issue: nodes {
                      __typename
                      databaseId
                      title
                      url
                      number
                      bodyText
                      comments {
                        totalCount
                      }
                      author {
                        login
                        avatarUrl
                        url
                      }
                      repository {
                        nameWithOwner
                        description
                        url
                      }
                      createdAt
                    }
                  }
                  issueComments(last: 10) {
                    issueComment:nodes {
                      __typename
                      databaseId
                      bodyText
                      createdAt
                      url
                      author {
                        login
                        avatarUrl
                        url
                      }
                      parentIssue: issue {
                        databaseId
                        url
                        createdAt
                        title
                        bodyText
                        author {
                          login
                          avatarUrl
                          url
                        }
                        comments {
                          totalCount
                        }
                        repository {
                          nameWithOwner
                          description
                          url
                        }
                        id
                        number
                      }
                    }
                  }
                  pullRequests(last: 10) {
                    pullRequest: nodes {
                      __typename
                      databaseId
                      title
                      url
                      number
                      baseRefName
                      headRefName
                      bodyText
                      createdAt
                      additions
                      deletions
                      comments {
                        totalCount
                      }
                      author {
                        login
                        avatarUrl
                        url
                      }
                      repository {
                        nameWithOwner
                        description
                        url
                      }
                    }
                  }
                  starredRepositories(last: 10) {
                    srEdges: edges {
                      createdAt: starredAt
                      __typename
                      star: node {
                        __typename
                        id
                        databaseId
                        nameWithOwner
                        description
                        forkCount
                        isFork
                        stargazers {
                          totalCount
                        }
                        updatedAt
                        url
                        owner {
                          avatarUrl
                        }
                        languages(first: 3, orderBy: {field: SIZE, direction: DESC}) {
                          language: nodes {
                            color
                            name
                          }
                        }
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

  Future<dynamic> searchUsers(String query) async {
    GQLResponse searchResponse;
    searchResponse = await client.query(
      query: r'''
        query ($user: String!) {
          search(query: $user, type: USER, first: 25) {
            userCount
            edges {
              node {
                ... on User {
                  id
                  login
                  avatarUrl
                  viewerIsFollowing
                  bio
                  name
                  url
                  company
                  status {
                    emoji
                    message
                  }
                }
              }
            }
          }
        }
      ''',
      headers: {'Authorization': 'Bearer $token'},
      variables: {"user": query},
    );
    return searchResponse.data;
  }

  //--- Mutations ---//

  /// Follow a user and return whether the operation was successful
  Future<bool> followUser(String userId) async {
    final GQLResponse followUserResponse = await client.mutation(
      mutation: r'''
        mutation FollowUser($input: FollowUserInput!) {
          followUser(input: $input) {
            clientMutationId
            user {
              viewerIsFollowing
            }
          }
        }
      ''',
      headers: {'Authorization': 'Bearer $token'},
      variables: {
        'input': {
          "userId": userId,
        },
      },
    );
    return followUserResponse.data['followUser']['user']['viewerIsFollowing'];
  }

  /// Unfollow a user and return whether the operation was successful
  Future<bool> unfollowUser(String userId) async {
    final GQLResponse unfollowUserResponse = await client.mutation(
      mutation: r'''
        mutation UnollowUser($input: UnfollowUserInput!) {
          unfollowUser(input: $input) {
            clientMutationId
            user {
              viewerIsFollowing
            }
          }
        }
      ''',
      headers: {'Authorization': 'Bearer $token'},
      variables: {
        'input': {
          "userId": userId,
        },
      },
    );
    return unfollowUserResponse.data['unfollowUser']['user']['viewerIsFollowing'];
  }
}
