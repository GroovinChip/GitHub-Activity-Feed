/// Custom Repository definition.
///
/// Used specifically for the getParentRepo() GraphQL query.
class ParentRepo {
  ParentRepo({
    this.url,
    this.description,
    this.nameWithOwner,
    this.forkCount,
    this.stargazerCount,
    this.watcherCount,
    this.languages,
  });

  final String url;
  final String nameWithOwner;
  final String description;
  final int forkCount;
  final int stargazerCount;
  final int watcherCount;
  final List<Language> languages;

  factory ParentRepo.fromJson(Map<String, dynamic> json) {
    List<Language> _languages = [];
    if (List<dynamic>.from(json['repository']['parent']['languages']['edges'])
        .isEmpty) {
      _languages.add(Language(
        name: 'N/A',
        color: '#6a737d',
      ));
    } else {
      _languages =
          List<dynamic>.from(json['repository']['parent']['languages']['edges'])
              .map((e) => Language.fromJson(e))
              .toList();
    }

    return ParentRepo(
      url: json['repository']['parent']['url'],
      nameWithOwner: json['repository']['parent']['nameWithOwner'],
      description: json['repository']['parent']['description'],
      forkCount: json['repository']['parent']['forkCount'],
      stargazerCount: json['repository']['parent']['stargazerCount'],
      watcherCount: json['repository']['parent']['watchers']['totalCount'],
      languages: _languages,
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
