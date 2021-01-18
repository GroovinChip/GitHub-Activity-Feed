import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:github_activity_feed/data/custom_repos.dart';
import 'package:github_activity_feed/data/following_users.dart';
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

  Future<Repo> getRepo(String name, String owner) async {
    GQLResponse response;
    try {
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
    } catch (e) {
      FirebaseCrashlytics.instance.log('Error when calling getRepo: $e');
      return null;
    }
  }

  /// This query returns a paginated list of users that the viewer follows
  Future<Following> getViewerFollowingPaginated(String endCursor) async {
    GQLResponse viewerFollowingResponse;
    try {
      viewerFollowingResponse = await client.query(
        query: r'''
          query($endCursor: String){
            viewer {
              following(first: 10, after: $endCursor) {
                totalCount
                pageInfo {
                  hasNextPage
                  endCursor
                }
                users: edges {
                  user: node {
                    id
                    login
                    url
                    avatarUrl
                    createdAt
                    bio
                    location
                    name
                    email
                    company
                    status {
                      emoji
                      message
                    }
                    viewerIsFollowing
                  }
                }
              }
            }
          }
        ''',
        headers: {'Authorization': 'Bearer $token'},
        variables: {"endCursor": endCursor},
      );
      return Following.fromJson(viewerFollowingResponse.data);
    } catch (e) {
      FirebaseCrashlytics.instance.log('Error when calling getRepo: $e');
      return null;
    }
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
}
