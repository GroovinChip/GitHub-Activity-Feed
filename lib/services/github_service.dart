import 'dart:async';

import 'package:flutter/foundation.dart' show ValueNotifier;
import 'package:github/github.dart';
import 'package:github/hooks.dart';
import 'package:github_activity_feed/data/activity_events/activity_feed_item.dart';
import 'package:github_activity_feed/data/activity_events/activity_fork.dart';
import 'package:github_activity_feed/data/activity_events/activity_pull_request.dart';
import 'package:github_activity_feed/data/activity_events/activity_repo.dart';
import 'package:github_activity_feed/services/auth_service.dart';
import 'package:github_activity_feed/services/graphql_service.dart';
import 'package:rxdart/rxdart.dart';

class GitHubService {
  GitHubService._(this._authService);

  final AuthService _authService;
  final _github = GitHub();
  final currentUser = ValueNotifier<CurrentUser>(null);
  StreamSubscription<AuthState> _authStateSub;

  static Future<GitHubService> init(AuthService authService) async {
    final service = GitHubService._(authService);
    await service._init();
    return service;
  }

  GitHub get github => _github;
  BehaviorSubject<bool> loadingFeed = BehaviorSubject<bool>.seeded(false);
  List<ActivityFeedItem> activityFeed = [];

  Future<void> _init() async {
    await _onAuthStateChanged(_authService.authState);
    _authStateSub = _authService.onAuthStateChanged.listen(_onAuthStateChanged);
  }

  void dispose() {
    _authStateSub.cancel();
    loadingFeed.close();
  }

  Future<void> _onAuthStateChanged(AuthState authState) async {
    _github.auth = _githubAuthForState(authState);
    currentUser.value =
        _github.auth.isAnonymous ? null : await _github.users.getCurrentUser();
    if (currentUser.value != null) {
      loadActivityFeed();
    }
  }

  Authentication _githubAuthForState(AuthState authState) {
    if (authState != AuthState.loggedOut) {
      return Authentication.withToken(authState.accessToken);
    } else {
      return Authentication.anonymous();
    }
  }

  void loadActivityFeed() {
    GraphQLService graphQLService = GraphQLService(token: github.auth.token);
    loadingFeed.add(true);
    github.activity
        .listEventsReceivedByUser(currentUser.value.login, pages: 30)
        .listen((event) {
      ActivityRepo activityRepo = ActivityRepo(
        createdAt: event.createdAt,
        event: event,
      );
      ActivityFork activityFork = ActivityFork(
        createdAt: event.createdAt,
        forkEvent: ForkEvent.fromJson(event.payload),
      );
      ActivityPullRequest activityPullRequest;
      String repoQuery;
      String userQuery;
      switch (event.type) {
        case 'CreateEvent':
          repoQuery = event.repo.name.split('/').first;
          userQuery = event.actor.login;
          activityRepo.action = 'created';
          break;
        case 'ForkEvent':
          repoQuery = activityFork.forkEvent.forkee.name;
          userQuery = activityFork.forkEvent.forkee.fullName.split('/').first;
          break;
        case 'IssueCommentEvent':
          break;
        case 'MemberEvent':
          break;
        case 'PullRequestEvent':
          activityPullRequest = ActivityPullRequest(
            event: event,
            createdAt: event.createdAt,
          );
          activityFeed.add(activityPullRequest);
          break;
        case 'WatchEvent':
          repoQuery = event.repo.name.split('/').last;
          userQuery = event.repo.name.split('/').first;
          activityRepo.action = 'starred';
          break;
        default:
          break;
      }
      if (repoQuery != null && userQuery != null) {
        graphQLService.getRepo(repoQuery, userQuery).asStream().listen((repo) {
          switch (event.type) {
            case 'CreateEvent':
            case 'WatchEvent':
              activityRepo.repo = repo;
              break;
            case 'ForkEvent':
              activityFork.repo = repo;
              break;
            default:
              break;
          }
        }).onDone(() {
          if (activityRepo.repo != null) {
            activityFeed.add(activityRepo);
          } else if (activityFork.repo != null) {
            activityFeed.add(activityFork);
          }
        });
      }
    }).onDone(() {
      activityFeed.sort((ActivityFeedItem item1, ActivityFeedItem item2) {
        return item2.createdAt.compareTo(item1.createdAt);
      });
      loadingFeed.add(false);
      print('Finished loading feed');
    });
  }

  Future<void> logOut() async {
    await _authService.logOut();
  }
}
