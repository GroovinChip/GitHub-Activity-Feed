/// Custom Repository definitions.
///
/// They are the same except for how they built from json

class Repo {
  Repo({
    this.owner,
    this.url,
    this.description,
    this.name,
    this.nameWithOwner,
    this.forkCount,
    this.stargazerCount,
    this.watcherCount,
    this.issueCount,
    this.languages,
    this.parent,
  });

  final Owner owner;
  final String url;
  final String name;
  final String nameWithOwner;
  final String description;
  final int forkCount;
  final int stargazerCount;
  final int watcherCount;
  final int issueCount;
  final List<Language> languages;
  final ParentRepo parent;

  factory Repo.fromJson(Map<String, dynamic> json) {
    List<Language> _languages = [];
    ParentRepo _parent;
    if (List<dynamic>.from(json['repository']['languages']['edges']).isEmpty) {
      _languages.add(Language(
        name: 'N/A',
        color: '#6a737d',
      ));
    } else {
      _languages = List<dynamic>.from(json['repository']['languages']['edges'])
          .map((e) => Language.fromJson(e))
          .toList();
    }

    if (json['repository']['parent'] != null) {
      _parent = ParentRepo.fromJson(json['repository']['parent']);
    }

    return Repo(
      owner: Owner.fromJson(json['repository']['owner']),
      url: json['repository']['url'],
      name: json['repository']['name'],
      nameWithOwner: json['repository']['nameWithOwner'],
      description: json['repository']['description'],
      forkCount: json['repository']['forkCount'],
      stargazerCount: json['repository']['stargazerCount'],
      watcherCount: json['repository']['watchers']['totalCount'],
      issueCount: json['repository']['issues']['totalCount'],
      languages: _languages,
      parent: _parent,
    );
  }
}

class ParentRepo {
  ParentRepo({
    this.owner,
    this.url,
    this.description,
    this.name,
    this.nameWithOwner,
    this.forkCount,
    this.stargazerCount,
    this.watcherCount,
    this.issueCount,
    this.languages,
  });

  final Owner owner;
  final String url;
  final String name;
  final String nameWithOwner;
  final String description;
  final int forkCount;
  final int stargazerCount;
  final int watcherCount;
  final int issueCount;
  final List<Language> languages;

  factory ParentRepo.fromJson(Map<String, dynamic> json) {
    List<Language> _languages = [];
    if (List<dynamic>.from(json['languages']['edges']).isEmpty) {
      _languages.add(Language(
        name: 'N/A',
        color: '#6a737d',
      ));
    } else {
      _languages = List<dynamic>.from(json['languages']['edges'])
          .map((e) => Language.fromJson(e))
          .toList();
    }

    return ParentRepo(
      owner: Owner.fromJson(json['owner']),
      url: json['url'],
      name: json['name'],
      nameWithOwner: json['nameWithOwner'],
      description: json['description'],
      forkCount: json['forkCount'],
      stargazerCount: json['stargazerCount'],
      watcherCount: json['watchers']['totalCount'],
      issueCount: json['totalCount'],
      languages: _languages,
    );
  }
}

/// Defines the owner of a repository
class Owner {
  Owner({
    this.avatarUrl,
    this.login,
    this.url,
  });

  final String avatarUrl;
  final String login;
  final String url;

  factory Owner.fromJson(Map<String, dynamic> json) {
    return Owner(
      avatarUrl: json['avatarUrl'],
      login: json['login'],
      url: json['url'],
    );
  }
}

/// Defines a programming language for a repository per GitHub's GraphQL schema
class Language {
  Language({
    this.name,
    this.color,
  });

  /// The name of the language
  final String name;

  /// The hex color value assigned to this language
  final String color;

  factory Language.fromJson(Map<String, dynamic> json) {
    return Language(
      name: json['language']['name'],
      color: json['language']['color'],
    );
  }
}
