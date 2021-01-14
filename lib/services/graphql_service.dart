import 'package:flutter/foundation.dart';
import 'package:github_activity_feed/data/custom_repos.dart';
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

  Future<Repo> getRepo(String name, String owner) async {
    GQLResponse response;
    response = await client.query(
      query: r'''
        query getParentRepo($name: String!, $owner: String!) {
          repository(name: $name, owner: $owner) {
            owner {
              avatarUrl
              login
              url
            }
            url
            description
            name
            nameWithOwner
            forkCount
            stargazerCount
            watchers {
              totalCount
            }
            issues {
              totalCount
            }
            languages(first: 3, orderBy: {field: SIZE, direction: DESC}) {
              pageInfo {
                hasNextPage
              }
              edges {
                language: node {
                  name
                  color
                }
              }
            }
            parent {
              owner {
                avatarUrl
                login
                url
              }
              url
              description
              name
              nameWithOwner
              forkCount
              stargazerCount
              watchers {
                totalCount
              }
              issues {
                totalCount
              }
              languages(first: 3, orderBy: {field: SIZE, direction: DESC}) {
                pageInfo {
                  hasNextPage
                }
                edges {
                  language: node {
                    name
                    color
                  }
                }
              }
            }
          }
        }''',
      headers: {'Authorization': 'Bearer $token'},
      variables: {"name": name, "owner": owner},
    );
    return Repo.fromJson(response.data);
  }
}
