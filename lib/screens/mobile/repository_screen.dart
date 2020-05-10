import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:github/github.dart';
import 'package:github_activity_feed/app/provided.dart';
import 'package:github_activity_feed/screens/widgets/mobile_activity_feed.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rxdart/rxdart.dart';

class RepositoryScreen extends StatefulWidget {
  RepositoryScreen({
    Key key,
    this.repository,
  }) : super(key: key);

  final Repository repository;

  @override
  _RepositoryScreenState createState() => _RepositoryScreenState();
}

class _RepositoryScreenState extends State<RepositoryScreen>
    with SingleTickerProviderStateMixin, ProvidedState {
  TabController _tabController;
  RepositorySlug _repositorySlug;

  @override
  void initState() {
    super.initState();
    _repositorySlug = RepositorySlug.full(widget.repository.fullName);
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
        titleSpacing: 8,
        title: Text(widget.repository.fullName),
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
        stream: CombineLatestStream.combine2(
          github.github.activity.listRepositoryEvents(_repositorySlug).toList().asStream(),
          github.github.repositories.getReadme(_repositorySlug).asStream().onErrorReturn(null),
          (List<Event> repositoryEvents, GitHubFile readme) => [repositoryEvents, readme],
        ),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData && snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          } else {
            List<Event> _repoEvents = snapshot.data.first;
            GitHubFile _readme = snapshot.data.last;
            return TabBarView(
              controller: _tabController,
              children: [
                _readme != null
                    ? Markdown(
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
                      )
                    : Center(
                        child: Text(
                          'No readme',
                          style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
                        ),
                      ),
                _repoEvents.length > 0
                    ? MobileActivityFeed(events: _repoEvents)
                    : Center(
                        child: Text(
                          'No recent commits',
                          style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
                        ),
                      ),
              ],
            );
          }
        },
      ),
    );
  }
}
