/// Represents a trending repository listed on https://github.com/trending.
/// GitHub does not provide a 'trending' API. We use https://githubtrendingapi.docs.apiary.io/.
class TrendingUser {
  TrendingUser({
    this.username,
    this.name,
    this.type,
    this.url,
    this.avatar,
    this.repo,
  });

  final String username;
  final String name;
  final String type;
  final String url;
  final String avatar;
  final Repo repo;

  factory TrendingUser.fromJson(Map<String, dynamic> json) {
    return TrendingUser(
      username: json['username'],
      name: json['name'],
      type: json['type'],
      url: json['url'],
      avatar: json['avatar'],
      repo: Repo.fromJson(json['repo']),
    );
  }
}

class Repo {
  Repo({
    this.name,
    this.description,
    this.url,
  });

  final String name;
  final String description;
  final String url;

  factory Repo.fromJson(Map<String, dynamic> json) {
    return Repo(
      name: json['name'],
      description: json['description'],
      url: json['url'],
    );
  }
}
