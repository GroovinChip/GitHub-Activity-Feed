import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:github/github.dart';
import 'package:github_activity_feed/app/provided.dart';
import 'package:github_activity_feed/screens/commit_list_screen.dart';
import 'package:github_activity_feed/utils/navigation_util.dart';
import 'package:github_activity_feed/widgets/pr_status_label.dart';
import 'package:github_activity_feed/widgets/report_bug_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:wiredash/wiredash.dart';

class PullRequestHeaderBar extends StatefulWidget {
  const PullRequestHeaderBar({
    Key key,
    this.pullRequest,
    this.action,
    this.commitsUrl,
  }) : super(key: key);

  final PullRequest pullRequest;
  final String action;
  final String commitsUrl;

  @override
  _PullRequestHeaderBarState createState() => _PullRequestHeaderBarState();
}

class _PullRequestHeaderBarState extends State<PullRequestHeaderBar> with ProvidedState {
  List<dynamic> _prCommits = [];
  Future _getCommits;

  Future<List<dynamic>> _getCommitsFromNetwork() async {
    final response = await http.get(widget.commitsUrl);
    return jsonDecode(response.body);
  }

  @override
  void initState() {
    super.initState();
    _getCommits = _getCommitsFromNetwork();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 8),
          child: Text(widget.pullRequest.head.repo.fullName),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 8),
          child: RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: '${widget.pullRequest.title}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
                TextSpan(text: ' #${widget.pullRequest.number}'),
              ],
            ),
          ),
        ),
        Row(
          children: [
            SizedBox(width: 16),
            Material(
              color: Colors.blue[800],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(6, 2, 6, 2),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.pullRequest.head.ref,
                      style: GoogleFonts.firaCode(),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 4, right: 4),
              child: Icon(
                Icons.arrow_forward,
                size: 20,
                color: Colors.grey,
              ),
            ),
            Material(
              color: Colors.blue[800],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(6, 2, 6, 2),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.pullRequest.base.ref,
                      style: GoogleFonts.firaCode(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Row(
          children: [
            SizedBox(width: 16),
            PullRequestStatusLabel(
              pullRequest: widget.pullRequest,
            ),
          ],
        ),
        FutureBuilder<List<dynamic>>(
          future: _getCommits,
          builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
            if (!snapshot.hasData && snapshot.connectionState == ConnectionState.waiting) {
              return ListTile(
                leading: Transform.rotate(
                  angle: 4.7,
                  child: Icon(MdiIcons.sourceCommit),
                ),
                title: Row(
                  children: [
                    Container(
                      height: 15,
                      width: 15,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                      ),
                    ),
                  ],
                ),
              );
            } else if (!snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
              return ListTile(
                leading: Transform.rotate(
                  angle: 4.7,
                  child: Icon(MdiIcons.sourceCommit),
                ),
                title: Text('Unable to get commit count'),
                trailing: ReportBugButton(),
              );
            } else {
              _prCommits = snapshot.data;
              return ListTile(
                leading: Transform.rotate(
                  angle: 4.7,
                  child: Icon(MdiIcons.sourceCommit),
                ),
                title: Text(
                  snapshot.data.length > 1
                      ? '${_prCommits.length} commits'
                      : '${_prCommits.length} commit',
                ),
                enabled: _prCommits.isNotEmpty,
                onTap: () => navigateToScreen(
                  context,
                  CommitListScreen(
                    repoName: widget.pullRequest.head.repo.fullName,
                    committedBy: widget.pullRequest.user,
                    commits: _prCommits,
                    fromEventType: 'PullRequest',
                  ),
                ),
              );
            }
          },
        ),
      ],
    );
  }
}
