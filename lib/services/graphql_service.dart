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
