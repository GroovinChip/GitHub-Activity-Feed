import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:github/github.dart';
import 'package:github_activity_feed/app/provided.dart';
import 'package:github_activity_feed/services/extensions.dart';
import 'package:github_activity_feed/utils/stream_helpers.dart';
import 'package:github_activity_feed/widgets/activity_feed.dart';
import 'package:github_activity_feed/widgets/async_markdown.dart';
import 'package:github_activity_feed/widgets/feedback_on_error.dart';
import 'package:github_activity_feed/widgets/repository_header_bar.dart';
import 'package:github_activity_feed/widgets/view_in_browser_button.dart';
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

  final _headerKey = GlobalKey();
  double _headerSize;

  final _repoOwner = BehaviorSubject<User>();
  final _repositoryFeed = BehaviorSubject<List<Event>>();
  final _repository = BehaviorSubject<Repository>();
  final _readme = BehaviorSubject<GitHubFile>();

  @override
  void initState() {
    super.initState();
    _repositorySlug = RepositorySlug.full(widget.event.repo.name);
    _getRepoOwner();
    _getRepo();
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
      () => githubService.github.users
          .getUser(_repoOwnerLogin)
          .then((User user) => _repoOwner.value = user),
    );
  }

  void _getRepo() {
    updateBehaviorSubjectAsync(
      _repository,
      () => githubService.github.repositories.getRepository(_repositorySlug),
    );
  }

  void _getHeaderSize(_) {
    final RenderBox headerBox = _headerKey.currentContext.findRenderObject();
    print('Header height: ${headerBox.getMaxIntrinsicHeight(headerBox.size.width)}');
    setState(() => _headerSize = headerBox.getMaxIntrinsicHeight(headerBox.size.width));
  }

  @override
  void dispose() {
    _repoOwner.close();
    _repository.close();
    _repositoryFeed.close();
    _readme.close();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: CombineLatestStream.list([
          _repoOwner,
          _repository,
          _readme,
        ]),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData && snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (!snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
            return FeedbackOnError(message: 'Error');
          } else {
            final owner = snapshot.data[0];
            final repository = snapshot.data[1];
            final readme = snapshot.data[2];
            WidgetsBinding.instance.addPostFrameCallback(_getHeaderSize);
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  titleSpacing: 8,
                  pinned: true,
                  automaticallyImplyLeading: false,
                  title: Row(
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
                    ViewInBrowserButton(url: repository.htmlUrl),
                  ],
                  expandedHeight: _headerSize ?? 150,
                  bottom: PreferredSize(
                    preferredSize: Size.fromHeight(_headerSize ?? 150),
                    child: RepositoryHeaderBar(
                      key: _headerKey,
                      repository: repository,
                      tabController: _tabController,
                    ),
                  ),
                ),
                SliverFillRemaining(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      /// Readme
                      AsyncMarkdown(
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
                          blockquoteDecoration: BoxDecoration(
                            color: Theme.of(context).brightness == Brightness.light
                                ? Colors.grey[300]
                                : Colors.grey[900],
                          ),
                          blockquote: TextStyle(
                            color: Theme.of(context).brightness == Brightness.light
                                ? Colors.black
                                : Colors.white,
                          ),
                        ),
                      ),

                      /// Feed
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
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
