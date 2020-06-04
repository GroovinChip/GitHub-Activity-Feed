import 'package:flutter/material.dart';
import 'package:github_activity_feed/data/activity_feed_models.dart';
import 'package:github_activity_feed/utils/extensions.dart';

class PullRequestPreview extends StatelessWidget {
  const PullRequestPreview({
    Key key,
    @required this.pullRequest,
  }) : super(key: key);

  final PullRequest pullRequest;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 56),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              border: Border.all(
                color: context.isDarkTheme ? Colors.grey : Colors.black,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  pullRequest.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  pullRequest.bodyText == '' ? 'No description' : pullRequest.bodyText,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    // todo: get additions/subtractions (?), style accordingly
                    Text(
                      '${pullRequest.changedFiles} changed files',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    // todo: comment count
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
