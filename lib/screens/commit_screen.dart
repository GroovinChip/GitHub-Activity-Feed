import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:github/github.dart';
import 'package:github_activity_feed/app/provided.dart';
import 'package:groovin_widgets/groovin_expansion_tile.dart';
import 'package:groovin_widgets/groovin_widgets.dart';

class CommitScreen extends StatefulWidget {
  CommitScreen({
    Key key,
    @required this.committedBy,
    this.repoName,
    @required this.commits,
  }) : super(key: key);

  final User committedBy;
  final String repoName;
  final List<dynamic> commits;

  @override
  _CommitScreenState createState() => _CommitScreenState();
}

class _CommitScreenState extends State<CommitScreen> with ProvidedState {
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
      ),
      body: ListView.builder(
        itemCount: widget.commits.length,
        itemBuilder: (BuildContext context, int index) {
          final _repoSlug = RepositorySlug.full(widget.repoName);
          return CommitCard(
            commit: widget.commits[index],
            repositorySlug: _repoSlug,
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
  }) : super(key: key);
  final GitCommit commit;
  final RepositorySlug repositorySlug;

  @override
  _CommitCardState createState() => _CommitCardState();
}

class _CommitCardState extends State<CommitCard> with ProvidedState {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<RepositoryCommit>(
      future: githubService.github.repositories.getCommit(
        widget.repositorySlug,
        widget.commit.sha,
      ),
      builder: (BuildContext context, AsyncSnapshot<RepositoryCommit> snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        } else {
          final repoCommit = snapshot.data;
          return Card(
            child: Column(
              children: [
                ListTile(
                  title: Text(repoCommit.files.first.name),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text('${repoCommit.files.first.changes} Changes'),
                    Text('${repoCommit.files.first.additions} Additions'),
                    Text('${repoCommit.files.first.deletions} Deletions'),
                  ],
                ),
                SizedBox(height: 8),
              ],
            ),
          );
        }
      },
    );
  }
}
