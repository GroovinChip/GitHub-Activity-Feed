import 'package:flutter/material.dart';
import 'package:github/github.dart';
import 'package:github_activity_feed/services/extensions.dart';

class IssueHeaderBar extends StatefulWidget {
  final Issue issue;

  const IssueHeaderBar({
    Key key,
    this.issue,
  }) : super(key: key);

  @override
  _IssueHeaderBarState createState() => _IssueHeaderBarState();
}

class _IssueHeaderBarState extends State<IssueHeaderBar> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12, bottom: 8, right: 12),
          child: RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: '${widget.issue.title} ',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: '#${widget.issue.number}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 12, bottom: 12, right: 12),
          child: Material(
            color: widget.issue.state == 'open' ? Colors.green : Colors.red,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(6, 2, 6, 2),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.info_outline),
                  SizedBox(width: 2),
                  Text(widget.issue.state.capitalize()),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
