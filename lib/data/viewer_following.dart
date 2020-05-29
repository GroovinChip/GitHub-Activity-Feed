class ViewerFollowing {
  bool viewerIsFollowing;

  ViewerFollowing({this.viewerIsFollowing});

  ViewerFollowing.fromJson(Map<String, dynamic> json) {
    viewerIsFollowing = json['viewerIsFollowing'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['viewerIsFollowing'] = this.viewerIsFollowing;
    return data;
  }
}
