class SearchResults {
  int userCount;
  List<SearchEdge> edges;

  SearchResults({this.userCount, this.edges});

  SearchResults.fromJson(Map<String, dynamic> json) {
    userCount = json['userCount'];
    if (json['edges'] != null) {
      edges = new List<SearchEdge>();
      json['edges'].forEach((v) {
        edges.add(new SearchEdge.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
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
    node = json['node'] != null ? new UserSearchNode.fromJson(json['node']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.node != null) {
      data['node'] = this.node.toJson();
    }
    return data;
  }
}

class UserSearchNode {
  String id;
  String login;
  String avatarUrl;
  bool viewerIsFollowing;
  String bio;
  String name;
  String url;
  String company;
  Status status;

  UserSearchNode({
    this.id,
    this.login,
    this.avatarUrl,
    this.viewerIsFollowing,
    this.bio,
    this.name,
    this.url,
    this.company,
    this.status,
  });

  UserSearchNode.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    login = json['login'];
    avatarUrl = json['avatarUrl'];
    viewerIsFollowing = json['viewerIsFollowing'];
    bio = json['bio'];
    name = json['name'];
    url = json['url'];
    company = json['company'];
    status = json['status'] != null ? new Status.fromJson(json['status']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['login'] = this.login;
    data['avatarUrl'] = this.avatarUrl;
    data['viewerIsFollowing'] = this.viewerIsFollowing;
    data['bio'] = this.bio;
    data['name'] = this.name;
    data['url'] = this.url;
    data['company'] = this.company;
    if (this.status != null) {
      data['status'] = this.status.toJson();
    }
    return data;
  }
}

class Status {
  String emoji;
  String message;

  Status({this.emoji, this.message});

  Status.fromJson(Map<String, dynamic> json) {
    emoji = json['emoji'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['emoji'] = this.emoji;
    data['message'] = this.message;
    return data;
  }
}
