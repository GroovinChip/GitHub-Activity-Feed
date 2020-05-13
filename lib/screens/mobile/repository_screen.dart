import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:github/github.dart';
import 'package:github_activity_feed/app/provided.dart';
import 'package:github_activity_feed/screens/widgets/mobile_activity_feed.dart';
import 'package:github_activity_feed/services/extensions.dart';
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
  String _userLogin;
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
    github.github.activity.isStarred(_repositorySlug).then((bool isStarred) {
      print(isStarred);
      setState(() => _isStarred = isStarred);
    });
  }

  void _getRepoActivity() {
    if (!_repositoryFeed.hasValue) {
      github.github.activity
          .listRepositoryEvents(_repositorySlug)
          .toList()
          .then((List<Event> repoEvents) => _repositoryFeed.value = repoEvents);
    }
  }

  void _getReadme() {
    if (!_readme.hasValue) {
      github.github.repositories
          .getReadme(_repositorySlug)
          .then((GitHubFile readme) => _readme.value = readme);
    }
  }

  void _getRepoOwner() {
    _userLogin = widget.event.repo.name.replaceAfter('/', '').replaceAll('/', '');
    if (!_repoOwner.hasValue) {
      github.github.users.getUser(_userLogin).then((User user) => _repoOwner.value = user);
    }
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
        title: _repoOwner.value != null
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AvatarBackButton(
                    avatar: _repoOwner.value?.avatarUrl,
                    onPressed: () => Navigator.pop(context),
                  ),
                  SizedBox(width: 16),
                  Text(_repositorySlug.name),
                ],
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  CircleAvatar(),
                ],
              ),
        actions: [
          IconButton(
            icon: Icon(!_isStarred ? Icons.star_border : Icons.star),
            onPressed: () {
              if (!_isStarred) {
                github.github.activity.star(_repositorySlug);
                setState(() => _isStarred = true);
              } else {
                github.github.activity.unstar(_repositorySlug);
                setState(() => _isStarred = false);
              }
            },
          ),
        ],
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
      body: TabBarView(
        controller: _tabController,
        children: [
          _readme.value != null
              ? Markdown(
                  data: _readme.value?.text,
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
          MobileActivityFeed(
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
