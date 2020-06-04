import 'package:github_activity_feed/utils/annotations.dart';
import 'package:github_activity_feed/utils/printers.dart';
import 'package:meta/meta.dart';
import 'package:github_activity_feed/data/gist.dart';

/// Generated using https://javiercbk.github.io/json_to_dart/

abstract class ActivityFeedItem {
  ActivityFeedItemType get type;
  DateTime get createdAt;
}

class ActivityFeedItemType {
  static const gist = ActivityFeedItemType._('Gist');
  static const issue = ActivityFeedItemType._('Issue');
  static const issueComment = ActivityFeedItemType._('IssueComment');
  static const pullRequest = ActivityFeedItemType._('PullRequest');
  static const starredRepoEdge = ActivityFeedItemType._('StarredRepositoryEdge');

  static const values = [
    gist,
    issue,
    issueComment,
    pullRequest,
    starredRepoEdge,
  ];

  static ActivityFeedItemType from(String value) {
    return values.firstWhere((el) => el.name == value);
  }

  const ActivityFeedItemType._(this.name);

  final String name;
}

class Following {
  Following({this.userActivity});

  List<UserActivity> userActivity;

  Following.fromJson(Map<String, dynamic> json) {
    if (json['user'] != null) {
      userActivity = List<UserActivity>();
      json['user'].forEach((v) {
        userActivity.add(UserActivity.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.userActivity != null) {
      data['user'] = this.userActivity.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

@immutable
class UserActivity {
  const UserActivity({
    this.userLogin,
    this.userAvatarUrl,
    this.userUrl,
    this.gists,
    this.issues,
    this.issueComments,
    this.pullRequests,
    this.starredRepositories,
  });

  final String userLogin;
  final String userAvatarUrl;
  final String userUrl;
  final Gists gists;
  final Issues issues;
  final IssueComments issueComments;
  final PullRequests pullRequests;
  final List<StarredRepoEdge> starredRepositories;

  factory UserActivity.fromJson(Map<String, dynamic> json) {
    final starredRepositories = <StarredRepoEdge>[];
    final activity = UserActivity(
      userLogin: json['login'],
      userAvatarUrl: json['avatarUrl'],
      userUrl: json['url'],
      gists: json['gists'] != null ? new Gists.fromJson(json['gists']) : null,
      issues: json['issues'] != null ? Issues.fromJson(json['issues']) : null,
      issueComments:
          json['issueComments'] != null ? IssueComments.fromJson(json['issueComments']) : null,
      pullRequests:
          json['pullRequests'] != null ? PullRequests.fromJson(json['pullRequests']) : null,
      starredRepositories: starredRepositories,
    );
    if (json['starredRepositories'] != null) {
      if (json['starredRepositories']['srEdges'] != null) {
        for (Map<String, dynamic> edge in json['starredRepositories']['srEdges']) {
          starredRepositories.add(StarredRepoEdge.fromJson(edge, activity));
        }
      }
    }
    return activity;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['login'] = this.userLogin;
    data['avatarUrl'] = this.userAvatarUrl;
    data['url'] = this.userUrl;
    if (this.gists != null) {
      data['gists'] = this.gists.toJson();
    }
    if (this.issues != null) {
      data['issues'] = this.issues.toJson();
    }
    if (this.issueComments != null) {
      data['issueComments'] = this.issueComments.toJson();
    }
    if (this.pullRequests != null) {
      data['pullRequests'] = this.pullRequests.toJson();
    }
    return data;
  }
}

class Issues {
  Issues({this.issues});

  List<Issue> issues;

  Issues.fromJson(Map<String, dynamic> json) {
    if (json['issue'] != null) {
      issues = List<Issue>();
      json['issue'].forEach((v) {
        issues.add(Issue.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.issues != null) {
      data['issue'] = this.issues.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Issue implements ActivityFeedItem {
  Issue({
    this.databaseId,
    this.title,
    this.url,
    this.number,
    this.bodyText,
    this.author,
    this.repository,
    this.createdAt,
  });

  ActivityFeedItemType get type => ActivityFeedItemType.issue;

  int databaseId;
  String title;
  String url;
  int number;
  String bodyText;
  Author author;
  Repository repository;
  DateTime createdAt;

  Issue.fromJson(Map<String, dynamic> json) {
    databaseId = json['databaseId'];
    title = json['title'];
    url = json['url'];
    number = json['number'];
    bodyText = json['bodyText'];
    author = json['author'] != null ? Author.fromJson(json['author']) : null;
    repository = json['repository'] != null ? Repository.fromJson(json['repository']) : null;
    createdAt = DateTime.parse(json['createdAt'] as String);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['__typename'] = this.type.name;
    data['databaseId'] = this.databaseId;
    data['title'] = this.title;
    data['url'] = this.url;
    data['number'] = this.number;
    data['bodyText'] = this.bodyText;
    if (this.author != null) {
      data['author'] = this.author.toJson();
    }
    if (this.repository != null) {
      data['repository'] = this.repository.toJson();
    }
    data['createdAt'] = this.createdAt;
    return data;
  }
}

class Author {
  Author({
    this.login,
    this.avatarUrl,
    this.url,
  });

  String login;
  String avatarUrl;
  String url;

  Author.fromJson(Map<String, dynamic> json) {
    login = json['login'];
    avatarUrl = json['avatarUrl'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['login'] = this.login;
    data['avatarUrl'] = this.avatarUrl;
    data['url'] = this.url;
    return data;
  }
}

class Repository {
  Repository({
    this.nameWithOwner,
    this.description,
    this.url,
  });

  String nameWithOwner;
  String description;
  String url;

  Repository.fromJson(Map<String, dynamic> json) {
    nameWithOwner = json['nameWithOwner'];
    description = json['description'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['nameWithOwner'] = this.nameWithOwner;
    data['description'] = this.description;
    data['url'] = this.url;
    return data;
  }
}

class IssueComments {
  IssueComments({this.issueComments});

  List<IssueComment> issueComments;

  IssueComments.fromJson(Map<String, dynamic> json) {
    if (json['issueComment'] != null) {
      issueComments = List<IssueComment>();
      json['issueComment'].forEach((v) {
        issueComments.add(IssueComment.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.issueComments != null) {
      data['issueComment'] = this.issueComments.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class IssueComment implements ActivityFeedItem {
  IssueComment({
    this.databaseId,
    this.bodyText,
    this.createdAt,
    this.url,
    this.author,
    this.parentIssue,
  });

  ActivityFeedItemType get type => ActivityFeedItemType.issueComment;

  int databaseId;
  String bodyText;
  DateTime createdAt;
  String url;
  Author author;
  ParentIssue parentIssue;

  IssueComment.fromJson(Map<String, dynamic> json) {
    databaseId = json['databaseId'];
    bodyText = json['bodyText'];
    createdAt = DateTime.parse(json['createdAt'] as String);
    url = json['url'];
    author = json['author'] != null ? Author.fromJson(json['author']) : null;
    parentIssue = json['parentIssue'] != null ? ParentIssue.fromJson(json['parentIssue']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['__typename'] = this.type.name;
    data['databaseId'] = this.databaseId;
    data['bodyText'] = this.bodyText;
    data['createdAt'] = this.createdAt;
    data['url'] = this.url;
    if (this.author != null) {
      data['author'] = this.author.toJson();
    }
    if (this.parentIssue != null) {
      data['parentIssue'] = this.parentIssue.toJson();
    }
    return data;
  }
}

class ParentIssue {
  ParentIssue({
    this.title,
    this.author,
    this.repository,
    this.id,
    this.number,
  });

  String title;
  Author author;
  Repository repository;
  String id;
  int number;

  ParentIssue.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    author = json['author'] != null ? Author.fromJson(json['author']) : null;
    repository = json['repository'] != null ? Repository.fromJson(json['repository']) : null;
    id = json['id'];
    number = json['number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['title'] = this.title;
    if (this.author != null) {
      data['author'] = this.author.toJson();
    }
    if (this.repository != null) {
      data['repository'] = this.repository.toJson();
    }
    data['id'] = this.id;
    data['number'] = this.number;
    return data;
  }
}

class PullRequests {
  PullRequests({this.pullRequests});

  List<PullRequest> pullRequests;

  PullRequests.fromJson(Map<String, dynamic> json) {
    if (json['pullRequest'] != null) {
      pullRequests = List<PullRequest>();
      json['pullRequest'].forEach((v) {
        pullRequests.add(PullRequest.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.pullRequests != null) {
      data['pullRequest'] = this.pullRequests.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PullRequest implements ActivityFeedItem {
  PullRequest({
    this.databaseId,
    this.title,
    this.url,
    this.number,
    this.baseRefName,
    this.headRefName,
    this.bodyText,
    this.createdAt,
    this.changedFiles,
    this.author,
    this.repository,
  });

  ActivityFeedItemType get type => ActivityFeedItemType.pullRequest;

  int databaseId;
  String title;
  String url;
  int number;
  String baseRefName;
  String headRefName;
  String bodyText;
  DateTime createdAt;
  int changedFiles;
  Author author;
  Repository repository;

  PullRequest.fromJson(Map<String, dynamic> json) {
    databaseId = json['databaseId'];
    title = json['title'];
    url = json['url'];
    number = json['number'];
    baseRefName = json['baseRefName'];
    headRefName = json['headRefName'];
    bodyText = json['bodyText'];
    createdAt = DateTime.parse(json['createdAt'] as String);
    changedFiles = json['changedFiles'];
    author = json['author'] != null ? Author.fromJson(json['author']) : null;
    repository = json['repository'] != null ? Repository.fromJson(json['repository']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['__typename'] = this.type.name;
    data['databaseId'] = this.databaseId;
    data['title'] = this.title;
    data['url'] = this.url;
    data['number'] = this.number;
    data['baseRefName'] = this.baseRefName;
    data['headRefName'] = this.headRefName;
    data['bodyText'] = this.bodyText;
    data['createdAt'] = this.createdAt;
    data['changedFiles'] = this.changedFiles;
    if (this.author != null) {
      data['author'] = this.author.toJson();
    }
    if (this.repository != null) {
      data['repository'] = this.repository.toJson();
    }
    return data;
  }
}

@immutable
class StarredRepoEdge implements ActivityFeedItem {
  const StarredRepoEdge({
    this.createdAt,
    this.star,
    this.userActivity,
  });

  ActivityFeedItemType get type => ActivityFeedItemType.starredRepoEdge;

  final DateTime createdAt;
  final Star star;

  @transient
  final UserActivity userActivity;

  factory StarredRepoEdge.fromJson(Map<String, dynamic> json, UserActivity userActivity) {
    return StarredRepoEdge(
      createdAt: DateTime.parse(json['createdAt'] as String),
      star: json['star'] != null ? Star.fromJson(json['star']) : null,
      userActivity: userActivity,
    );
  }
}

class Star {
  Star(
      {this.sTypename,
      this.id,
      this.databaseId,
      this.nameWithOwner,
      this.description,
      this.forkCount,
      this.isFork,
      this.stargazers,
      this.updatedAt,
      this.url,
      this.languages});

  final String sTypename;
  final String id;
  final int databaseId;
  final String nameWithOwner;
  final String description;
  final int forkCount;
  final bool isFork;
  final Stargazers stargazers;
  final String updatedAt;
  final String url;
  final List<Language> languages;

  factory Star.fromJson(Map<String, dynamic> json) {
    final _languages = <Language>[];
    if (json['languages'] != null) {
      json['languages']['language'].forEach(
        (l) => _languages.add(Language.fromJson(l)),
      );
    }
    return Star(
      sTypename: json['__typename'],
      id: json['id'],
      databaseId: json['databaseId'],
      nameWithOwner: json['nameWithOwner'],
      description: json['description'],
      forkCount: json['forkCount'],
      isFork: json['isFork'],
      stargazers: Stargazers.fromJson(json['stargazers']),
      updatedAt: json['updatedAt'],
      url: json['url'],
      languages: _languages,
    );
  }
}

/// A count of users who have starred a repository.
class Stargazers {
  Stargazers({this.totalCount});

  int totalCount;

  Stargazers.fromJson(Map<String, dynamic> json) {
    totalCount = json['totalCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['totalCount'] = this.totalCount;
    return data;
  }
}

/// Represents a given language found in repositories.
class Language {
  Language({
    this.color,
    this.name,
  });

  /// The color defined for the current language.
  final String color;

  /// The name of the current language.
  final String name;

  factory Language.fromJson(Map<String, dynamic> json) {
    return Language(
      color: json['color'],
      name: json['name'],
    );
  }
}
