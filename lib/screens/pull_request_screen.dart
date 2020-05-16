import 'package:flutter/material.dart';
import 'package:github/github.dart';
import 'package:github/hooks.dart';
import 'package:github_activity_feed/app/provided.dart';
import 'package:github_activity_feed/screens/widgets/custom_stream_builder.dart';
import 'package:github_activity_feed/utils/stream_helpers.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:rxdart/rxdart.dart';

class PullRequestScreen extends StatefulWidget {
  PullRequestScreen({
    Key key,
    this.repoName,
    this.event,
  }) : super(key: key);

  final String repoName;
  final PullRequestEvent event;

  @override
  _PullRequestScreenState createState() => _PullRequestScreenState();
}

class _PullRequestScreenState extends State<PullRequestScreen> with ProvidedState {
  final _headerKey = GlobalKey();
  double headerSize;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_getHeaderSize);
  }

  void _getHeaderSize(_) {
    final RenderBox headerBox = _headerKey.currentContext.findRenderObject();
    setState(() => headerSize = headerBox.getMaxIntrinsicHeight(headerBox.size.width));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            snap: true,
            floating: true,
            expandedHeight: headerSize ?? 0.0,
            title: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                '${widget.event.pullRequest.title}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(headerSize ?? 0.0),
              child: Container(
                alignment: Alignment.centerLeft,
                child: PullRequestHeaderBar(
                  key: _headerKey,
                  pullRequest: widget.event.pullRequest,
                  action: widget.event.action,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Center(
                child: Text('AAAA'),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}

class PullRequestHeaderBar extends StatelessWidget {
  const PullRequestHeaderBar({
    Key key,
    this.pullRequest,
    this.action,
  }) : super(key: key);

  final PullRequest pullRequest;
  final String action;

  @override
  Widget build(BuildContext context) {
    print(pullRequest.toJson());
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                    Text(pullRequest.head.ref),
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
                  children: [Text(pullRequest.base.ref)],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Row(
          children: [
            SizedBox(width: 16),
            Material(
              color: Colors.deepPurple[700],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(6, 2, 6, 2),
                child: Row(
                  children: [
                    Icon(MdiIcons.sourcePull, size: 20),
                    SizedBox(width: 4),
                    Text(action),
                  ],
                ),
              ),
            ),
          ],
        ),
        ListTile(
          leading: Transform.rotate(
            angle: 4.7,
            child: Icon(MdiIcons.sourceCommit),
          ),
          title: Text('X commits'),
        ),
      ],
    );
  }
}
