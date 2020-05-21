import 'package:flutter/material.dart';
import 'package:github_activity_feed/widgets/report_bug_button.dart';

class FeedbackOnError extends StatelessWidget {
  const FeedbackOnError({
    @required this.message,
    Key key,
  }) : super(key: key);

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(message),
          ReportBugButton(),
        ],
      ),
    );
  }
}
