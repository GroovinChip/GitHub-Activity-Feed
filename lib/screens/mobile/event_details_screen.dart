import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:github/github.dart';
import 'package:github_activity_feed/app/provided.dart';
import 'package:github_activity_feed/screens/widgets/mobile_activity_feed.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:groovin_widgets/avatar_back_button.dart';
import 'package:rxdart/rxdart.dart';

class EventDetailsScreen extends StatefulWidget {
  EventDetailsScreen({
    Key key,
    @required this.event,
  }) : super(key: key);

  final Event event;

  @override
  _EventDetailsScreenState createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> with SingleTickerProviderStateMixin, ProvidedState {
  User get actor => widget.event.actor;
  Repository get repo => widget.event.repo;
  RepositorySlug _repositorySlug;
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _repositorySlug = RepositorySlug.full(repo.name);
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 8,
        title: Row(
          children: [
            AvatarBackButton(
              avatar: actor.avatarUrl,
              onPressed: () => Navigator.pop(context),
            ),
            SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(actor.login),
                Text(
                  repo.name.replaceAll('${actor.login}/', ''),
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Theme.of(context).colorScheme.secondary,
          tabs: [
            Tab(
              text: 'Readme',
            ),
            Tab(
              text: 'Activity',
            ),
          ],
        ),
      ),
      body: StreamBuilder(
        stream: CombineLatestStream.combine3(
          github.github.repositories.getRepository(_repositorySlug).asStream(),
          github.github.activity.listRepositoryEvents(_repositorySlug).toList().asStream(),
          github.github.repositories.getReadme(_repositorySlug).asStream(),
          (Repository repository, List<Event> repositoryEvents, GitHubFile readme) => [repository, repositoryEvents, readme],
        ),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            Repository _repo = snapshot.data.first;
            List<Event> _repoEvents = snapshot.data[1];
            GitHubFile _readme = snapshot.data.last;
            return TabBarView(
              controller: _tabController,
              children: [
                Markdown(
                  data: _readme.text,
                  styleSheet: MarkdownStyleSheet(
                    h1: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    h2: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    h3: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    h4: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground,
                      fontWeight: FontWeight.bold,
                    ),
                    p: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                    listBullet: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                    code: GoogleFonts.firaCode(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                ),
                MobileActivityFeed(events: _repoEvents),
              ],
            );
          }
        },
      ),
    );
  }
}
