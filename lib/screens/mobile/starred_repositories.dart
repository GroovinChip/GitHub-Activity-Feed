import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:github/github.dart';
import 'package:github_activity_feed/app/provided.dart';
import 'package:github_activity_feed/screens/mobile/repository_screen.dart';

class StarredRepositories extends StatefulWidget {
  StarredRepositories({
    Key key,
    this.user,
    this.starredRepositories,
  }) : super(key: key);

  final User user;
  final List<Repository> starredRepositories;

  @override
  _StarredRepositoriesState createState() => _StarredRepositoriesState();
}

class _StarredRepositoriesState extends State<StarredRepositories> with ProvidedState {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.user.login}\'s stars'),
      ),
      body: Scrollbar(
        child: ListView.builder(
          itemCount: widget.starredRepositories.length,
          itemBuilder: (context, index) {
            final starredRepo = widget.starredRepositories[index];
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
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(starredRepo.owner.avatarUrl),
                      ),
                      title: Text(starredRepo.fullName),
                      /*trailing: IconButton(
                        icon: Icon(Icons.star),
                        onPressed: () => setState(() {
                          RepositorySlug _repoSlug = RepositorySlug.full(starredRepo.name);
                          widget.starredRepositories.removeAt(index);
                          github.github.activity.unstar(_repoSlug);
                        }),
                      ),*/
                    ),
                  ),
                );
              },
              openBuilder: (BuildContext context, action) {
                return RepositoryScreen(
                  repository: starredRepo,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
