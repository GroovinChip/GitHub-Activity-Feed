import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:github/github.dart';
import 'package:github_activity_feed/app/provided.dart';
import 'package:github_activity_feed/services/extensions.dart';
import 'package:github_activity_feed/utils/stream_helpers.dart';
import 'package:github_activity_feed/widgets/activity_feed.dart';
import 'package:github_activity_feed/widgets/feedback_on_error.dart';
import 'package:github_activity_feed/widgets/github_markdown.dart';
import 'package:github_activity_feed/widgets/repository_header_bar.dart';
import 'package:github_activity_feed/widgets/view_in_browser_button.dart';
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
  Size _headerSize;

  final _repoOwner = BehaviorSubject<User>();
  final _repositoryFeed = BehaviorSubject<List<Event>>();
  final _repository = BehaviorSubject<Repository>();
  final _readme = BehaviorSubject<GitHubFile>();

  @override
  void initState() {
    super.initState();
    //todo: refactor all this out into a service (or something)
    if (widget.repository != null) {
      _repositorySlug = RepositorySlug.full(widget.repository.fullName);
      _repository.value = widget.repository;
      _getRepoOwner(widget.repository.owner.login);
      _getRepoActivity();
      _checkIfStarred();
      _getReadme();
    } else {
      _repositorySlug = RepositorySlug.full(widget.event.repo.name);
      _getRepoOwner(widget.event.repo.name);
      _getRepo();
      _getReadme();
      _getRepoActivity();
      _checkIfStarred();
    }
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

  void _getRepoOwner(String name) {
    _repoOwnerLogin = name.replaceAfter('/', '').replaceAll('/', '');
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
    setState(() => _headerSize = headerBox.size);
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
            final User owner = snapshot.data[0];
            final Repository repository = snapshot.data[1];
            final GitHubFile readme = snapshot.data[2];

            /// Calling this here doesn't seem right, but doing it in initState doesn't return the size
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
                  expandedHeight: _headerSize?.height ?? 150,
                  bottom: PreferredSize(
                    preferredSize: Size.fromHeight(_headerSize?.height ?? 150),
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
                      GitHubMarkdown(
                        markdown: readme.text,
                        useScrollable: true,
                      ),

                      /// Feed
                      ActivityFeed(),
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
