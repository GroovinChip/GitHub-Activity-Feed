import 'package:github_activity_feed/data/base_user.dart';

class Following {
  Following({
    this.totalCount = 0,
    this.hasNextPage = false,
    this.endCursor,
    this.users,
  });

  int totalCount;
  bool hasNextPage;
  String endCursor;
  List<FollowingUser> users;

  factory Following.fromJson(Map<String, dynamic> json) {
    List<FollowingUser> _users = [];
    int _totalCount;
    bool _hasNextPage;
    String _endCursor;

    if (json['viewer']['following'] != null) {
      _totalCount = json['viewer']['following']['totalCount'];
      _hasNextPage = json['viewer']['following']['pageInfo']['hasNextPage'];
      _endCursor = json['viewer']['following']['pageInfo']['endCursor'];
      json['viewer']['following']['users'].forEach((v) {
        _users.add(FollowingUser.fromJson(v));
      });
    }

    return Following(
      totalCount: _totalCount,
      hasNextPage: _hasNextPage,
      endCursor: _endCursor,
      users: _users,
    );
  }

  //testme
  Map<String, dynamic> toJson() {
    return {
      'totalCount': totalCount ?? 0,
      'users': users.map((user) => user.toJson()).toList(),
    };
  }
}

class FollowingUser extends BaseUser {
  FollowingUser({
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

  factory FollowingUser.fromJson(Map<String, dynamic> json) {
    Status _status;
    if (json['user']['status'] != null) {
      _status = Status.fromJson(json['user']['status']);
    }

    return FollowingUser(
      id: json['user']['id'],
      login: json['user']['login'],
      url: json['user']['url'],
      avatarUrl: json['user']['avatarUrl'],
      createdAt: json['user']['createdAt'],
      viewerIsFollowing: json['user']['viewerIsFollowing'],
      bio: json['user']['bio'],
      location: json['user']['location'],
      name: json['user']['name'],
      email: json['user']['email'],
      company: json['user']['company'],
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
