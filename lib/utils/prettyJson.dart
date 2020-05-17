import 'dart:convert';

import 'package:flutter/cupertino.dart';

void printPrettyJson(Object json) {
  JsonEncoder encoder = new JsonEncoder.withIndent('  ');
  String prettyJson = encoder.convert(json);
  debugPrint(prettyJson);
}