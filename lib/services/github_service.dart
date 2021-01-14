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

  List<ActivityFeedItem> feedV2 = [];

  void loadActivityFeed() {
    loadingFeed.add(true);
    github.activity
        .listEventsReceivedByUser(currentUser.value.login, pages: 30)
        .listen((event) {
      switch (event.type) {
        case 'CreateEvent':
          ActivityCreate activityCreate = ActivityCreate(
            createdAt: event.createdAt,
            event: event,
          );
          github.repositories
              .getRepository(RepositorySlug.full(event.repo.name))
              .asStream()
              .listen((repo) {
            activityCreate.repository = repo;
          }).onDone(() {
            if (activityCreate.repository != null) {
              feedV2.add(activityCreate);
            }
          });
          break;
        case 'ForkEvent':
          ActivityFork activityFork = ActivityFork(
            createdAt: event.createdAt,
            forkEvent: ForkEvent.fromJson(event.payload),
          );
          GraphQLService graphQLService =
              GraphQLService(token: github.auth.token);
          graphQLService
              .getParentRepo(activityFork.forkEvent.forkee.name,
                  activityFork.forkEvent.forkee.fullName.split('/').first)
              .asStream()
              .listen((parent) {
            activityFork.parent = parent;
          }).onDone(() {
            github.users
                .getUser(activityFork.parent.nameWithOwner.split('/').first)
                .asStream()
                .listen((user) {
              activityFork.parentOwner = user;
            }).onDone(() {
              feedV2.add(activityFork);
            });
          });
          break;
        default:
          break;
      }
      activityFeed.add(event);
    }).onDone(() {
      loadingFeed.add(false);
      print('Finished loading feed');
      print(activityFeed.length);
    });
  }

  Future<void> logOut() async {
    await _authService.logOut();
  }
}
