import 'base_user.dart';

/// Generated using https://javiercbk.github.io/json_to_dart/
class SearchResults {
  SearchResults({
    this.userCount,
    this.hasNextPage,
    this.endCursor,
    this.users,
  });
  
  final int userCount;
  final bool hasNextPage;
  final String endCursor;
  final List<UserFromSearch> users;

  factory SearchResults.fromJson(Map<String, dynamic> json) {
    List<UserFromSearch> _users = [];
    if (json['edges'] != null) {
      json['edges'].forEach((v) {
        _users.add(UserFromSearch.fromJson(v['user']));
      });
    }

    return SearchResults(
      userCount: json['userCount'],
      hasNextPage: json['pageInfo']['hasNextPage'],
      endCursor: json['pageInfo']['endCursor'],
      users: _users,
    );
  }
}

class UserFromSearch extends BaseUser {
  UserFromSearch({
    this.id,
    this.login,
    this.url,
    this.avatarUrl,
    this.createdAt,
    this.viewerIsFollowing,
    this.bio,
    this.location,
    this.name,
    this.email,
    this.company,
    this.status,
  });

  final String location;
  final String company;
  final Status status;
  final String id;
  final String login;
  final String url;
  final String avatarUrl;
  final String createdAt;
  final bool viewerIsFollowing;
  final String bio;
  final String name;
  final String email;

  factory UserFromSearch.fromJson(Map<String, dynamic> json) {
    Status _status;
    if (json['status'] != null) {
      _status = Status.fromJson(json['status']);
    }

    return UserFromSearch(
      id: json['id'],
      login: json['login'],
      url: json['url'],
      avatarUrl: json['avatarUrl'],
      createdAt: json['createdAt'],
      viewerIsFollowing: json['viewerIsFollowing'],
      bio: json['bio'],
      location: json['location'],
      name: json['name'],
      email: json['email'],
      company: json['company'],
      status: _status,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['login'] = this.login;
    data['url'] = this.url;
    data['avatarUrl'] = this.avatarUrl;
    data['createdAt'] = this.createdAt;
    data['viewerIsFollowing'] = this.viewerIsFollowing;
    data['bio'] = this.bio;
    data['location'] = this.location;
    data['name'] = this.name;
    data['email'] = this.email;
    data['company'] = this.company;
    if (this.status != null) {
      data['status'] = this.status.toJson();
    }
    return data;
  }
}
