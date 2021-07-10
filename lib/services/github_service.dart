import 'dart:async';

import 'package:flutter/foundation.dart' show ValueNotifier;
import 'package:github/github.dart';
import 'package:github/hooks.dart';
import 'package:github_activity_feed/data/activity_events/activity_feed_item.dart';
import 'package:github_activity_feed/data/activity_events/activity_fork.dart';
import 'package:github_activity_feed/data/activity_events/activity_member.dart';
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
  List<ActivityFeedItem> activityFeed = [];
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

  Future<void> loadActivityFeed() async {
    loadingFeed.add(true);
    activityFeed.clear();
    GraphQLService graphQLService = GraphQLService(token: github.auth.token);
    loadingFeed.add(true);
    final _events = await github.activity
        .listEventsReceivedByUser(currentUser.value.login, pages: 30)
        .toList();

    for (final event in _events) {
      String repoQuery;
      String userQuery;
      ActivityRepo activityRepo = ActivityRepo(
        createdAt: event.createdAt,
        event: event,
      );
      switch (event.type) {
        case 'CreateEvent':
          repoQuery = event.repo.name.split('/').first;
          userQuery = event.actor.login;
          activityRepo.action = 'created';

          final repo = await graphQLService.getRepo(repoQuery, userQuery);

          if (repo != null) {
            activityRepo.repo = repo;
            activityFeed.add(activityRepo);
          }

          break;
        case 'ForkEvent':
          ActivityFork activityFork = ActivityFork(
            createdAt: event.createdAt,
            forkEvent: ForkEvent.fromJson(event.payload),
          );
          repoQuery = activityFork.forkEvent.forkee.name;
          userQuery = activityFork.forkEvent.forkee.fullName.split('/').first;

          final repo = await graphQLService.getRepo(repoQuery, userQuery);
          if (repo != null) {
            activityFork.repo = repo;
            activityFeed.add(activityFork);
          }

          break;
        case 'MemberEvent':
          ActivityMember activityMember = ActivityMember(
            event: event,
            createdAt: event.createdAt,
          );
          repoQuery = event.repo.name;
          userQuery = event.actor.login;

          final repo = await graphQLService.getRepo(repoQuery, userQuery);

          if (repo != null) {
            activityMember.repo = repo;
            activityFeed.add(activityMember);
          }

          break;
        case 'PullRequestEvent':
          ActivityPullRequest activityPullRequest = ActivityPullRequest(
            event: event,
            createdAt: event.createdAt,
          );

          activityFeed.add(activityPullRequest);

          break;
        case 'WatchEvent':
          repoQuery = event.repo.name.split('/').last;
          userQuery = event.repo.name.split('/').first;
          activityRepo.action = 'starred';

          final repo = await graphQLService.getRepo(repoQuery, userQuery);

          if (repo != null) {
            activityRepo.repo = repo;
            activityFeed.add(activityRepo);
          }

          break;
      }
    }

    if (activityFeed.isNotEmpty) {
      activityFeed.sort((ActivityFeedItem item1, ActivityFeedItem item2) {
        return item2.createdAt.compareTo(item1.createdAt);
      });
    }

    loadingFeed.add(false);
    print('Finished loading feed');
  }

  Future<void> logOut() async {
    await _authService.logOut();
  }
}

extension ActivityX on ActivityService {
  /// List the events received by the authenticated user.
  Stream<Event> listEventsReceivedByUser(String userLogin, {int pages}) {
    return PaginationHelper(github).objects(
      'GET',
      '/users/$userLogin/received_events',
      (i) => Event.fromJson(i),
      pages: pages,
    );
  }
}

extension EventTypeX on Event {
  String get action {
    switch (this.type) {
      case 'ForkEvent':
        return '${this.actor.login} forked ${this.repo.name}';
      case 'ReleaseEvent':
        return '${this.actor.login} released a new version of ${this.repo.name}';
      case 'WatchEvent':
        return '${this.actor.login} starred ${this.repo.name}';
      case 'CreateEvent':
        if (this.payload['ref'] == null) {
          return '${this.actor.login} created ${this.payload['ref_type']} ${this.repo.name}';
        }
        return '${this.actor.login} created ${this.payload['ref_type']} ${this.payload['ref']} at ${this.repo.name}';
      case 'PushEvent':
        final branch = this.payload['ref'].split('/').last;
        return '${this.actor.login} pushed ${this.payload['size']} commits to $branch at ${this.repo.name}';
      case 'PullRequestEvent':
        final prNum = this.payload['number'];
        return '${this.actor.login} opened pull request #$prNum at ${this.repo.name}';
      case 'IssueCommentEvent':
        final issueNum = this.payload['issue']['url'].split('issues/').last;
        return '${this.actor.login} commented on issue #$issueNum at ${this.repo.name}';
      case 'IssuesEvent':
        final issueNum = this.payload['issue']['url'].split('issues/').last;
        return '${this.actor.login} ${this.payload['action']} issue #$issueNum at ${this.repo.name}';
      case 'PublicEvent':
        return '${this.actor.login} made ${this.repo.name} public';
      case 'MemberEvent':
        return '${this.payload['member']['login']} was added to ${this.repo.name}';
      case 'PullRequestReviewEvent':
        return '${this.actor.login} reviewed pull request #${this.payload['pull_request']['url'].split('/').last} to ${this.repo.name}';
      case 'PullRequestReviewCommentEvent':
        return '${this.actor.login} commented on pull request #${this.payload['pull_request']['url'].split('/').last} to ${this.repo.name}';
      case 'DeleteEvent':
        return '${this.actor.login} deleted ${this.payload['ref_type']} ${this.payload['ref']} at ${this.repo.name}';
      default:
        print(this.type);
        return '';
    }
  }
}