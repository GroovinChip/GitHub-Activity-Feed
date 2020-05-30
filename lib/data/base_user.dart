abstract class BaseUser {
  String get id;
  String get login;
  String get url;
  String get avatarUrl;
  String get createdAt;
  bool get viewerIsFollowing;
  String get name;
  String get email;
  String get bio;
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
