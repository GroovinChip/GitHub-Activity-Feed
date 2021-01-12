import 'package:github_activity_feed/data/base_user.dart';

/// Generated using https://javiercbk.github.io/json_to_dart/
class FollowingUsers {
  Following following;

  FollowingUsers({this.following});

  FollowingUsers.fromJson(Map<String, dynamic> json) {
    following = json['following'] != null ? Following.fromJson(json['following']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.following != null) {
      data['following'] = this.following.toJson();
    }
    return data;
  }
}

class Following {
  int totalCount;
  List<FollowingUser> users;

  Following({
    this.totalCount,
    this.users,
  });

  Following.fromJson(Map<String, dynamic> json) {
    totalCount = json['totalCount'];
    if (json['users'] != null) {
      users = <FollowingUser>[];
      json['users'].forEach((v) {
        users.add(FollowingUser.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['totalCount'] = this.totalCount;
    if (this.users != null) {
      data['users'] = this.users.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FollowingUser extends BaseUser {
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

  factory FollowingUser.fromJson(Map<String, dynamic> json) {
    return FollowingUser(
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
      status: json['status'] != null ? Status.fromJson(json['status']) : null,
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
