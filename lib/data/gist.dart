import 'package:github_activity_feed/data/activity_feed_models.dart';
import 'package:github_activity_feed/data/user.dart';

/// Generated using https://javiercbk.github.io/json_to_dart/

class Gists {
  List<Gist> gist;

  Gists({this.gist});

  Gists.fromJson(Map<String, dynamic> json) {
    if (json['gist'] != null) {
      gist = <Gist>[];
      json['gist'].forEach((v) {
        gist.add(Gist.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.gist != null) {
      data['gist'] = this.gist.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Gist implements ActivityFeedItem {
  Gist({
    this.description,
    this.createdAt,
    this.files,
    this.owner,
    this.url,
    this.commentCount,
    this.starredCount,
    this.forkCount,
  });

  ActivityFeedItemType get type => ActivityFeedItemType.gist;

  String description;
  DateTime createdAt;
  List<Files> files;
  User owner;
  String url;
  int commentCount;
  int starredCount;
  int forkCount;

  Gist.fromJson(Map<String, dynamic> json) {
    description = json['description'];
    createdAt = DateTime.parse(json['createdAt'] as String);
    if (json['files'] != null) {
      files = <Files>[];
      json['files'].forEach((v) {
        files.add(Files.fromJson(v));
      });
    }
    owner = json['owner'] != null ? User.fromJson(json['owner']) : null;
    url = json['url'];
    commentCount = json['comments']['totalCount'];
    starredCount = json['stargazers']['totalCount'];
    forkCount = json['forks']['totalCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['__typename'] = this.type;
    data['description'] = this.description;
    data['createdAt'] = this.createdAt;
    if (this.files != null) {
      data['files'] = this.files.map((v) => v.toJson()).toList();
    }
    if (this.owner != null) {
      data['owner'] = this.owner.toJson();
    }
    data['url'] = this.url;
    data['commentCount'] = this.commentCount;
    data['starredCount'] = this.starredCount;
    data['forkCount'] = this.forkCount;
    return data;
  }
}

class Files {
  String name;

  Files({this.name});

  Files.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['name'] = this.name;
    return data;
  }
}
