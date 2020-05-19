import 'package:flutter/material.dart';
import 'package:github/github.dart';

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
