import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:github/github.dart';
import 'package:github_activity_feed/app/provided.dart';
import 'package:github_activity_feed/screens/widgets/async_markdown.dart';
import 'package:github_activity_feed/screens/widgets/custom_stream_builder.dart';
import 'package:github_activity_feed/screens/widgets/activity_feed.dart';
import 'package:github_activity_feed/services/extensions.dart';
import 'package:github_activity_feed/utils/stream_helpers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:groovin_widgets/avatar_back_button.dart';
import 'package:rxdart/rxdart.dart';

class RepositoryScreen extends StatefulWidget {
  RepositoryScreen({
    Key key,
    this.event,
    this.repository,
  }) : super(key: key);

  /// If coming to this screen from an event feed, an Event should be passed.
  final Event event;

  /// If coming to this screen from a list of repositories, a Repository should be passed.
  final Repository repository;

  @override
  _RepositoryScreenState createState() => _RepositoryScreenState();
}

class _RepositoryScreenState extends State<RepositoryScreen>
    with SingleTickerProviderStateMixin, ProvidedState {
  TabController _tabController;
  String _repoOwnerLogin;
  RepositorySlug _repositorySlug;
  bool _isStarred = false;

  final _repoOwner = BehaviorSubject<User>();
  final _repositoryFeed = BehaviorSubject<List<Event>>();
  final _readme = BehaviorSubject<GitHubFile>();

  @override
  void initState() {
    super.initState();
    _repositorySlug = RepositorySlug.full(widget.event.repo.name);
    _getRepoOwner();
    _getReadme();
    _getRepoActivity();
    _checkIfStarred();
    _tabController = TabController(length: 2, vsync: this);
  }

  void _checkIfStarred() {
    githubService.github.activity.isStarred(_repositorySlug).then((bool isStarred) {
      setState(() {
        if (!_repositoryFeed.isClosed) {
          _isStarred = isStarred;
        }
      });
    });
  }

  void _getRepoActivity() {
    updateBehaviorSubjectAsync(
      _repositoryFeed,
      () => githubService.github.activity.listRepositoryEvents(_repositorySlug).toList(),
    );
  }

  void _getReadme() {
    updateBehaviorSubjectAsync(
      _readme,
      () => githubService.github.repositories.getReadme(_repositorySlug),
    );
  }

  void _getRepoOwner() {
    _repoOwnerLogin = widget.event.repo.name.replaceAfter('/', '').replaceAll('/', '');
    updateBehaviorSubjectAsync(
      _repoOwner,
      () => githubService.github.users.getUser(_repoOwnerLogin).then((User user) => _repoOwner.value = user),
    );
  }

  @override
  void dispose() {
    _repoOwner.close();
    _repositoryFeed.close();
    _readme.close();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 8,
        automaticallyImplyLeading: false,
        title: SubjectStreamBuilder(
          subject: _repoOwner,
          builder: (BuildContext context, User owner) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AvatarBackButton(
                  avatar: owner.avatarUrl,
                  onPressed: () => Navigator.pop(context),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(_repositorySlug.name),
                  ),
                ),
              ],
            );
          },
          loadingBuilder: (BuildContext context) {
            return InkWell(
              onTap: () => Navigator.pop(context),
              customBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.arrow_back),
                  CircleAvatar(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(!_isStarred ? Icons.star_border : Icons.star),
            onPressed: () {
              if (!_isStarred) {
                githubService.github.activity.star(_repositorySlug);
                setState(() => _isStarred = true);
              } else {
                githubService.github.activity.unstar(_repositorySlug);
                setState(() => _isStarred = false);
              }
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Theme.of(context).colorScheme.secondary,
          tabs: [
            Tab(text: 'Readme'),
            Tab(text: 'Activity'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          SubjectStreamBuilder(
            subject: _readme,
            builder: (BuildContext context, GitHubFile readme) {
              return AsyncMarkdown(
                data: readme.text,
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
              );
            },
            errorBuilder: (context, error) {
              return Center(
                child: Text('$error'),
              );
            },
          ),
          ActivityFeed(
            events: _repositoryFeed,
            emptyBuilder: (BuildContext context) {
              return Center(
                child: Text('No activity found'),
              );
            },
          ),
        ],
      ),
    );
  }
}
