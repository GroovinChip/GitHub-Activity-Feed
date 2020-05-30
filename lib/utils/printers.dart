import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:github_activity_feed/data/base_user.dart';
import 'package:intl/intl.dart';

void printPrettyJson(Object json) {
  JsonEncoder encoder = new JsonEncoder.withIndent('  ');
  String prettyJson = encoder.convert(json);
  debugPrint(prettyJson);
}

void printFormattedBaseUser(BaseUser user) {
  print('User: {\n'
      '  id: ${user.id},\n'
      '  name: ${user.name},\n'
      '  login: ${user.login},\n'
      '  url: ${user.url},\n'
      '  avatarUrl: ${user.avatarUrl},\n'
      '  createdAt: ${DateFormat.yMMMd().format(DateTime.parse(user.createdAt))},\n'
      '  email: ${user.email.isEmpty ? '[n/a]' : user.email},\n'
      '  bio: ${user.bio.isEmpty ? '[n/a]' : user.bio},\n'
      '  viewerIsFollowing: ${user.viewerIsFollowing},\n'
      '}');
}
