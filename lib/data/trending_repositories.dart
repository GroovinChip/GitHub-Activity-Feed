/// Represents a trending repository listed on https://github.com/trending
/// GitHub does not provide a 'trending' API. We use https://githubtrendingapi.docs.apiary.io/.
class TrendingRepository {
  TrendingRepository({
    this.author,
    this.name,
    this.avatar,
    this.url,
    this.description,
    this.language,
    this.languageColor,
    this.stars,
    this.forks,
    this.currentPeriodStars,
    this.builtBy,
  });

  final String author;
  final String name;
  final String avatar;
  final String url;
  final String description;
  final String language;
  final String languageColor;
  final int stars;
  final int forks;
  final int currentPeriodStars;
  final List<BuiltBy> builtBy;

  factory TrendingRepository.fromJson(Map<String, dynamic> json) {
    List<BuiltBy> builtBy = List<BuiltBy>();
    if (json['builtBy'] != null) {
      json['builtBy'].forEach((v) {
        builtBy.add(new BuiltBy.fromJson(v));
      });
    }
    return TrendingRepository(
      author: json['author'],
      name: json['name'],
      avatar: json['avatar'],
      url: json['url'],
      description: json['description'],
      language: json['language'],
      languageColor: json['languageColor'],
      stars: json['stars'],
      forks: json['forks'],
      currentPeriodStars: json['currentPeriodStars'],
      builtBy: builtBy,
    );
  }
}

/// A short representation of the repository author
class BuiltBy {
  BuiltBy({
    this.username,
    this.href,
    this.avatar,
  });

  final String username;
  final String href;
  final String avatar;

  factory BuiltBy.fromJson(Map<String, dynamic> json) {
    return BuiltBy(
      username: json['username'],
      href: json['href'],
      avatar: json['avatar'],
    );
  }
}
