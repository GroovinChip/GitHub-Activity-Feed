import 'package:flutter/material.dart';
import 'package:github/github.dart';
import 'package:github_activity_feed/app/provided.dart';
import 'package:github_activity_feed/screens/repository_screen.dart';
import 'package:github_activity_feed/utils/navigation_util.dart';

class RepositoryList extends StatefulWidget {
  RepositoryList({
    Key key,
    @required this.user,
    this.starredList,
  }) : super(key: key);

  final User user;
  final bool starredList;

  @override
  _RepositoryListState createState() => _RepositoryListState();
}

class _RepositoryListState extends State<RepositoryList> with ProvidedState {
  List<Repository> repositories;

  @override
  void initState() {
    super.initState();
    //todo: get all this into state management
    if (widget.starredList) {
      githubService.github.activity
          .listStarredByUser(widget.user.login)
          .toList()
          .then((List<Repository> starred) {
        setState(() => repositories = starred);
      });
    } else {
      githubService.github.repositories
          .listUserRepositories(widget.user.login)
          .toList()
          .then((List<Repository> repos) {
        setState(() => repositories = repos);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.starredList
            ? '${widget.user.login}\'s stars'
            : '${widget.user.login}\'s repositories'),
      ),
      body: repositories != null
          ? Scrollbar(
              child: ListView.builder(
                itemCount: repositories.length,
                padding: const EdgeInsets.only(left: 8, right: 8, top: 4),
                itemBuilder: (BuildContext context, int index) {
                  final repository = repositories[index];
                  return Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: ListTile(
                      /*onTap: () => navigateToScreen(
                        context,
                        RepositoryScreen(
                          key: Key('repo-${repository.id}'),
                          repository: repository,
                        ),
                      ),*/
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(repository.owner.avatarUrl),
                      ),
                      title: Text(repository.fullName),
                      //subtitle: repository.isFork ? Text('forked from') : Container(),
                    ),
                  );
                },
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
