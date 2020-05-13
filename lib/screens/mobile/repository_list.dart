import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:github/github.dart';
import 'package:github_activity_feed/screens/mobile/repository_screen.dart';

class RepositoryList extends StatefulWidget {
  RepositoryList({
    Key key,
    @required this.user,
    @required this.repositories,
  }) : super(key: key);

  final User user;
  final List<Repository> repositories;

  @override
  _RepositoryListState createState() => _RepositoryListState();
}

class _RepositoryListState extends State<RepositoryList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.user.login}\'s repositories'),
      ),
      body: Scrollbar(
        child: ListView.builder(
          itemCount: widget.repositories.length,
          padding: const EdgeInsets.only(left: 8, right: 8),
          itemBuilder: (BuildContext context, int index) {
            final repository = widget.repositories[index];
            return OpenContainer(
              closedColor: Theme.of(context).canvasColor,
              closedBuilder: (BuildContext context, action) {
                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: ListTileTheme(
                    textColor: Theme.of(context).colorScheme.onBackground,
                    child: ListTile(
                      title: Text(repository.fullName),
                      //subtitle: repository.isFork ? Text('forked from') : Container(),
                    ),
                  ),
                );
              },
              openBuilder: (BuildContext context, action) {
                return RepositoryScreen(
                  repository: repository,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
