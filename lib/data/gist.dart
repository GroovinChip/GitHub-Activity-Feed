/// Generated using https://javiercbk.github.io/json_to_dart/

class Gists {
  List<Gist> gist;

  Gists({this.gist});

  Gists.fromJson(Map<String, dynamic> json) {
    if (json['gist'] != null) {
      gist = new List<Gist>();
      json['gist'].forEach((v) {
        gist.add(new Gist.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.gist != null) {
      data['gist'] = this.gist.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Gist {
  String sTypename;
  String description;
  String createdAt;
  List<Files> files;
  Owner owner;
  String url;

  Gist({
    this.sTypename,
    this.description,
    this.createdAt,
    this.files,
    this.owner,
    this.url,
  });

  Gist.fromJson(Map<String, dynamic> json) {
    sTypename = json['__typename'];
    description = json['description'];
    createdAt = json['createdAt'];
    if (json['files'] != null) {
      files = new List<Files>();
      json['files'].forEach((v) {
        files.add(new Files.fromJson(v));
      });
    }
    owner = json['owner'] != null ? new Owner.fromJson(json['owner']) : null;
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['__typename'] = this.sTypename;
    data['description'] = this.description;
    data['createdAt'] = this.createdAt;
    if (this.files != null) {
      data['files'] = this.files.map((v) => v.toJson()).toList();
    }
    if (this.owner != null) {
      data['owner'] = this.owner.toJson();
    }
    data['url'] = this.url;
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

class Owner {
  String login;
  String avatarUrl;
  String url;

  Owner({this.login, this.avatarUrl, this.url});

  Owner.fromJson(Map<String, dynamic> json) {
    login = json['login'];
    avatarUrl = json['avatarUrl'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['login'] = this.login;
    data['avatarUrl'] = this.avatarUrl;
    data['url'] = this.url;
    return data;
  }
}
