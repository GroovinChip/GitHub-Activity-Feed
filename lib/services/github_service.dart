import 'dart:async';

import 'package:flutter/foundation.dart' show ValueNotifier;
import 'package:github/github.dart';
import 'package:github/hooks.dart';
import 'package:github_activity_feed/data/activity_events.dart';
import 'package:github_activity_feed/data/activity_feed_item.dart';
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
  List<Event> activityFeed = [];
  BehaviorSubject<bool> loadingFeed = BehaviorSubject<bool>.seeded(false);

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
      _loadActivityFeed();
    }
  }

  Authentication _githubAuthForState(AuthState authState) {
    if (authState != AuthState.loggedOut) {
      return Authentication.withToken(authState.accessToken);
    } else {
      return Authentication.anonymous();
    }
  }

  List<ActivityFeedItem> feedV2 = [];

  void _loadActivityFeed() {
    GraphQLService graphQLService = GraphQLService(token: github.auth.token);
    loadingFeed.add(true);
    github.activity
        .listEventsReceivedByUser(currentUser.value.login, pages: 30)
        .listen((event) {
      ActivityCreate activityCreate = ActivityCreate(
        createdAt: event.createdAt,
        event: event,
      );
      ActivityFork activityFork = ActivityFork(
        createdAt: event.createdAt,
        forkEvent: ForkEvent.fromJson(event.payload),
      );
      String repoQuery;
      String userQuery;
      switch (event.type) {
        case 'CreateEvent':
          repoQuery = event.repo.name.split('/').first;
          userQuery = event.actor.login;
          break;
        case 'ForkEvent':
          repoQuery = activityFork.forkEvent.forkee.name;
          userQuery = activityFork.forkEvent.forkee.fullName.split('/').first;
          break;
        default:
          break;
      }
      if (repoQuery != null && userQuery != null) {
        graphQLService.getRepo(repoQuery, userQuery).asStream().listen((repo) {
          switch (event.type) {
            case 'CreateEvent':
              activityCreate.repo = repo;
              break;
            case 'ForkEvent':
              activityFork.repo = repo;
              break;
            default:
              break;
          }
        }).onDone(() {
          if (activityFork.repo != null) {
            feedV2.add(activityFork);
          }
        });
      }

      activityFeed.add(event);
    }).onDone(() {
      feedV2.sort((ActivityFeedItem item1, ActivityFeedItem item2) {
        return item2.createdAt.compareTo(item1.createdAt);
      });
      loadingFeed.add(false);
      print('Finished loading feed');
      print(activityFeed.length);
    });
  }

  Future<void> logOut() async {
    await _authService.logOut();
  }
}
