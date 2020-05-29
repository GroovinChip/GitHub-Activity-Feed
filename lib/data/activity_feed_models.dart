class Following {
  List<UserActivity> user;

  Following({this.user});

  Following.fromJson(Map<String, dynamic> json) {
    if (json['user'] != null) {
      user = new List<UserActivity>();
      json['user'].forEach((v) {
        user.add(new UserActivity.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UserActivity {
  Issues issues;
  IssueComments issueComments;
  PullRequests pullRequests;
  StarredRepositories starredRepositories;

  UserActivity({this.issues, this.issueComments, this.pullRequests, this.starredRepositories});

  UserActivity.fromJson(Map<String, dynamic> json) {
    issues = json['issues'] != null ? new Issues.fromJson(json['issues']) : null;
    issueComments = json['issueComments'] != null ? new IssueComments.fromJson(json['issueComments']) : null;
    pullRequests = json['pullRequests'] != null ? new PullRequests.fromJson(json['pullRequests']) : null;
    starredRepositories = json['starredRepositories'] != null ? new StarredRepositories.fromJson(json['starredRepositories']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.issues != null) {
      data['issues'] = this.issues.toJson();
    }
    if (this.issueComments != null) {
      data['issueComments'] = this.issueComments.toJson();
    }
    if (this.pullRequests != null) {
      data['pullRequests'] = this.pullRequests.toJson();
    }
    if (this.starredRepositories != null) {
      data['starredRepositories'] = this.starredRepositories.toJson();
    }
    return data;
  }
}

class Issues {
  List<Issue> issues;

  Issues({this.issues});

  Issues.fromJson(Map<String, dynamic> json) {
    if (json['issue'] != null) {
      issues = new List<Issue>();
      json['issue'].forEach((v) {
        issues.add(new Issue.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.issues != null) {
      data['issue'] = this.issues.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Issue {
  String sTypename;
  int databaseId;
  String title;
  String url;
  int number;
  String bodyText;
  Author author;
  Repository repository;
  String createdAt;

  Issue({this.sTypename, this.databaseId, this.title, this.url, this.number, this.bodyText, this.author, this.repository, this.createdAt});

  Issue.fromJson(Map<String, dynamic> json) {
    sTypename = json['__typename'];
    databaseId = json['databaseId'];
    title = json['title'];
    url = json['url'];
    number = json['number'];
    bodyText = json['bodyText'];
    author = json['author'] != null ? new Author.fromJson(json['author']) : null;
    repository = json['repository'] != null ? new Repository.fromJson(json['repository']) : null;
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['__typename'] = this.sTypename;
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
  String login;
  String avatarUrl;
  String url;

  Author({this.login, this.avatarUrl, this.url});

  Author.fromJson(Map<String, dynamic> json) {
    login = json['login'];
    avatarUrl = json['avatarUrl'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['login'] = this.login;
    data['avatarUrl'] = this.avatarUrl;
    data['url'] = this.url;
    return data;
  }
}

class Repository {
  String nameWithOwner;
  String description;
  String url;

  Repository({this.nameWithOwner, this.description, this.url});

  Repository.fromJson(Map<String, dynamic> json) {
    nameWithOwner = json['nameWithOwner'];
    description = json['description'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nameWithOwner'] = this.nameWithOwner;
    data['description'] = this.description;
    data['url'] = this.url;
    return data;
  }
}

class IssueComments {
  List<IssueComment> issueComments;

  IssueComments({this.issueComments});

  IssueComments.fromJson(Map<String, dynamic> json) {
    if (json['issueComment'] != null) {
      issueComments = new List<IssueComment>();
      json['issueComment'].forEach((v) {
        issueComments.add(new IssueComment.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.issueComments != null) {
      data['issueComment'] = this.issueComments.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class IssueComment {
  String sTypename;
  int databaseId;
  String bodyText;
  String createdAt;
  String url;
  Author author;
  ParentIssue parentIssue;

  IssueComment({this.sTypename, this.databaseId, this.bodyText, this.createdAt, this.url, this.author, this.parentIssue});

  IssueComment.fromJson(Map<String, dynamic> json) {
    sTypename = json['__typename'];
    databaseId = json['databaseId'];
    bodyText = json['bodyText'];
    createdAt = json['createdAt'];
    url = json['url'];
    author = json['author'] != null ? new Author.fromJson(json['author']) : null;
    parentIssue = json['parentIssue'] != null ? new ParentIssue.fromJson(json['parentIssue']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['__typename'] = this.sTypename;
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
  String title;
  Author author;
  Repository repository;
  String id;
  int number;

  ParentIssue({this.title, this.author, this.repository, this.id, this.number});

  ParentIssue.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    author = json['author'] != null ? new Author.fromJson(json['author']) : null;
    repository = json['repository'] != null ? new Repository.fromJson(json['repository']) : null;
    id = json['id'];
    number = json['number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
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
  List<PullRequest> pullRequests;

  PullRequests({this.pullRequests});

  PullRequests.fromJson(Map<String, dynamic> json) {
    if (json['pullRequest'] != null) {
      pullRequests = new List<PullRequest>();
      json['pullRequest'].forEach((v) {
        pullRequests.add(new PullRequest.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.pullRequests != null) {
      data['pullRequest'] = this.pullRequests.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PullRequest {
  String sTypename;
  int databaseId;
  String title;
  String url;
  int number;
  String baseRefName;
  String headRefName;
  String bodyText;
  String createdAt;
  int changedFiles;
  Author author;
  Repository repository;

  PullRequest(
      {this.sTypename,
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
      this.repository});

  PullRequest.fromJson(Map<String, dynamic> json) {
    sTypename = json['__typename'];
    databaseId = json['databaseId'];
    title = json['title'];
    url = json['url'];
    number = json['number'];
    baseRefName = json['baseRefName'];
    headRefName = json['headRefName'];
    bodyText = json['bodyText'];
    createdAt = json['createdAt'];
    changedFiles = json['changedFiles'];
    author = json['author'] != null ? new Author.fromJson(json['author']) : null;
    repository = json['repository'] != null ? new Repository.fromJson(json['repository']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['__typename'] = this.sTypename;
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

class StarredRepositories {
  List<SrEdge> srEdges;

  StarredRepositories({this.srEdges});

  StarredRepositories.fromJson(Map<String, dynamic> json) {
    if (json['srEdges'] != null) {
      srEdges = new List<SrEdge>();
      json['srEdges'].forEach((v) {
        srEdges.add(new SrEdge.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.srEdges != null) {
      data['srEdges'] = this.srEdges.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SrEdge {
  String createdAt;
  String sTypename;
  Star star;

  SrEdge({this.createdAt, this.sTypename, this.star});

  SrEdge.fromJson(Map<String, dynamic> json) {
    createdAt = json['createdAt'];
    sTypename = json['__typename'];
    star = json['star'] != null ? new Star.fromJson(json['star']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createdAt'] = this.createdAt;
    data['__typename'] = this.sTypename;
    if (this.star != null) {
      data['star'] = this.star.toJson();
    }
    return data;
  }
}

class Star {
  String sTypename;
  String id;
  int databaseId;
  String nameWithOwner;
  String description;
  int forkCount;
  bool isFork;
  Stargazers stargazers;
  String updatedAt;
  String url;

  Star(
      {this.sTypename, this.id, this.databaseId, this.nameWithOwner, this.description, this.forkCount, this.isFork, this.stargazers, this.updatedAt, this.url});

  Star.fromJson(Map<String, dynamic> json) {
    sTypename = json['__typename'];
    id = json['id'];
    databaseId = json['databaseId'];
    nameWithOwner = json['nameWithOwner'];
    description = json['description'];
    forkCount = json['forkCount'];
    isFork = json['isFork'];
    stargazers = json['stargazers'] != null ? new Stargazers.fromJson(json['stargazers']) : null;
    updatedAt = json['updatedAt'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['__typename'] = this.sTypename;
    data['id'] = this.id;
    data['databaseId'] = this.databaseId;
    data['nameWithOwner'] = this.nameWithOwner;
    data['description'] = this.description;
    data['forkCount'] = this.forkCount;
    data['isFork'] = this.isFork;
    if (this.stargazers != null) {
      data['stargazers'] = this.stargazers.toJson();
    }
    data['updatedAt'] = this.updatedAt;
    data['url'] = this.url;
    return data;
  }
}

class Stargazers {
  int totalCount;

  Stargazers({this.totalCount});

  Stargazers.fromJson(Map<String, dynamic> json) {
    totalCount = json['totalCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalCount'] = this.totalCount;
    return data;
  }
}
