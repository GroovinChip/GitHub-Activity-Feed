import 'base_user.dart';

/// Generated using https://javiercbk.github.io/json_to_dart/
class SearchResults {
  int userCount;
  List<SearchEdge> edges;

  SearchResults({
    this.userCount,
    this.edges,
  });

  SearchResults.fromJson(Map<String, dynamic> json) {
    userCount = json['userCount'];
    if (json['edges'] != null) {
      edges = <SearchEdge>[];
      json['edges'].forEach((v) {
        edges.add(SearchEdge.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['userCount'] = this.userCount;
    if (this.edges != null) {
      data['edges'] = this.edges.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SearchEdge {
  UserSearchNode node;

  SearchEdge({this.node});

  SearchEdge.fromJson(Map<String, dynamic> json) {
    node = json['node'] != null ? UserSearchNode.fromJson(json['node']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.node != null) {
      data['node'] = this.node.toJson();
    }
    return data;
  }
}

class UserSearchNode extends BaseUser {
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

  UserSearchNode({
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

  factory UserSearchNode.fromJson(Map<String, dynamic> json) {
    return UserSearchNode(
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
