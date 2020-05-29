class FollowingUsers {
  Following following;

  FollowingUsers({this.following});

  FollowingUsers.fromJson(Map<String, dynamic> json) {
    following = json['following'] != null ? new Following.fromJson(json['following']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.following != null) {
      data['following'] = this.following.toJson();
    }
    return data;
  }
}

class Following {
  int totalCount;
  List<FollowingUser> users;

  Following({this.totalCount, this.users});

  Following.fromJson(Map<String, dynamic> json) {
    totalCount = json['totalCount'];
    if (json['users'] != null) {
      users = new List<FollowingUser>();
      json['users'].forEach((v) {
        users.add(new FollowingUser.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalCount'] = this.totalCount;
    if (this.users != null) {
      data['users'] = this.users.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FollowingUser {
  String id;
  String login;
  String url;
  String avatarUrl;
  String createdAt;
  bool viewerIsFollowing;
  String bio;
  String location;
  String name;
  String email;
  String company;
  Status status;

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

  FollowingUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    login = json['login'];
    url = json['url'];
    avatarUrl = json['avatarUrl'];
    createdAt = json['createdAt'];
    viewerIsFollowing = json['viewerIsFollowing'];
    bio = json['bio'];
    location = json['location'];
    name = json['name'];
    email = json['email'];
    company = json['company'];
    status = json['status'] != null ? new Status.fromJson(json['status']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
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
