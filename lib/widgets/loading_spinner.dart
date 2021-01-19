import 'package:flutter/material.dart';
import 'package:github_activity_feed/utils/extensions.dart';

class LoadingSpinner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(context.theme.primaryColor),
    );
  }
}
