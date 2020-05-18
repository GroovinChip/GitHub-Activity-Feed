import 'package:flutter/material.dart';
import 'package:github/github.dart';
import 'package:github_activity_feed/app/provided.dart';
import 'package:github_activity_feed/services/extensions.dart';
import 'package:github_activity_feed/utils/prettyJson.dart';
import 'package:groovin_widgets/groovin_widgets.dart';

class CommitListScreen extends StatefulWidget {
  CommitListScreen({
    Key key,
    @required this.committedBy,
    @required this.repoName,
    @required this.commits,
    @required this.fromEventType,
  }) : super(key: key);

  final User committedBy;
  final String repoName;
  final List<dynamic> commits;
  final String fromEventType;

  @override
  _CommitListScreenState createState() => _CommitListScreenState();
}

class _CommitListScreenState extends State<CommitListScreen> with ProvidedState {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 8,
        title: Row(
          children: [
            AvatarBackButton(
              avatar: widget.committedBy.avatarUrl,
              onPressed: () => Navigator.pop(context),
            ),
            SizedBox(width: 16),
            Text('Commits by ${widget.committedBy.login}'),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(25),
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 4),
            child: Row(
              children: [
                FittedBox(
                  alignment: Alignment.centerLeft,
                  fit: BoxFit.scaleDown,
                  child: Text(
                    '${widget.repoName}',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: widget.commits.length,
        padding: const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
        itemBuilder: (BuildContext context, int index) {
          final _repoSlug = RepositorySlug.full(widget.repoName);
          return CommitCard(
            commit: widget.commits[index],
            repositorySlug: _repoSlug,
            type: widget.fromEventType,
          );
        },
      ),
    );
  }
}

class CommitCard extends StatefulWidget {
  const CommitCard({
    Key key,
    @required this.commit,
    @required this.repositorySlug,
    @required this.type,
  }) : super(key: key);

  final dynamic commit;
  final RepositorySlug repositorySlug;
  final String type;

  @override
  _CommitCardState createState() => _CommitCardState();
}

class _CommitCardState extends State<CommitCard> {
  String commitMessage = '';
  GitCommit gitCommit;
  RepositoryCommit repositoryCommit;
  String sha;

  @override
  void initState() {
    super.initState();
    //printPrettyJson(widget.commit);
    if (widget.type == 'PullRequest') {
      setState(() {
        repositoryCommit = RepositoryCommit.fromJson(widget.commit);
        commitMessage = repositoryCommit.commit.message;
        sha = repositoryCommit.sha;
      });
    } else {
      setState(() {
        gitCommit = widget.commit;
        commitMessage = gitCommit.message;
        sha = gitCommit.sha;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: RichText(
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                text: sha.substring(0, 7),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  decoration: TextDecoration.underline,
                ),
              ),
              TextSpan(
                text: ' $commitMessage',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
