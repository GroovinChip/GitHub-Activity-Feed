class User {
  User({
    this.login,
    this.avatarUrl,
    this.url,
  });

  final String login;
  final String avatarUrl;
  final String url;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      login: json['login'],
      avatarUrl: json['avatarUrl'],
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['login'] = this.login;
    data['avatarUrl'] = this.avatarUrl;
    data['url'] = this.url;
    return data;
  }
}
