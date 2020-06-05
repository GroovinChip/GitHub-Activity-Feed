import 'package:flutter/material.dart';
import 'package:github_activity_feed/data/activity_feed_models.dart';
import 'package:github_activity_feed/utils/extensions.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class PullRequestPreview extends StatefulWidget {
  const PullRequestPreview({
    Key key,
    @required this.pullRequest,
  }) : super(key: key);

  final PullRequest pullRequest;

  @override
  _PullRequestPreviewState createState() => _PullRequestPreviewState();
}

class _PullRequestPreviewState extends State<PullRequestPreview> {
  Color prIconColor;
  IconData prIcon;

  @override
  void initState() {
    super.initState();
    if (widget.pullRequest.merged && widget.pullRequest.closed) {
      prIcon = MdiIcons.sourceMerge;
      prIconColor = Color(0xff9878D3);
    } else if (!widget.pullRequest.merged && !widget.pullRequest.closed) {
      prIcon = MdiIcons.sourcePull;
      prIconColor = Color(0xff7EE195);
    } else if (!widget.pullRequest.merged && widget.pullRequest.closed) {
      prIcon = MdiIcons.sourcePull;
      prIconColor = Color(0xffD7616B);
    } else {
      prIcon = MdiIcons.sourcePull;
      prIconColor = Color(0xff7EE195);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
              ),
              borderRadius: BorderRadius.circular(8.0),
              color: context.isDarkTheme ? context.colorScheme.background : Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      prIcon,
                      size: 18,
                      color: prIconColor,
                    ),
                    SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        widget.pullRequest.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  widget.pullRequest.bodyText == '' ? 'No description' : widget.pullRequest.bodyText,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    color: context.isDarkTheme ? Colors.grey : Colors.grey.shade800,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    // todo: get additions/subtractions (?), style accordingly
                    Text(
                      '+${widget.pullRequest.additions}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.green,
                      ),
                    ),
                    SizedBox(width: 4),
                    Text(
                      '-${widget.pullRequest.deletions}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.red,
                      ),
                    ),
                    SizedBox(width: 16),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          MdiIcons.commentMultiple,
                          size: 18,
                          color: context.isDarkTheme ? Colors.grey : Colors.grey.shade800,
                        ),
                        SizedBox(width: 8),
                        Text(
                          '${widget.pullRequest.commentCount} comments',
                          style: TextStyle(
                            color: context.isDarkTheme ? Colors.grey : Colors.grey.shade800,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // todo: mergedAt/closedAt time?
              ],
            ),
          ),
        ),
      ],
    );
  }
}
