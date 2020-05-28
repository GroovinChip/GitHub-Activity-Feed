import 'dart:async';

import 'package:flutter/material.dart';
import 'package:github_activity_feed/app/provided.dart';
import 'package:github_activity_feed/screens/settings_screen.dart';
import 'file:///C:/Users/groov/Flutter_Projects/github_activity_feed/lib/utils/extensions.dart';
import 'package:github_activity_feed/services/gh_gql_query_service.dart';
import 'package:github_activity_feed/widgets/feedback_on_error.dart';
import 'package:github_activity_feed/widgets/user_profile.dart';
import 'package:github_activity_feed/widgets/view_in_browser_button.dart';
import 'package:groovin_widgets/avatar_back_button.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class UserOverview extends StatefulWidget {
  UserOverview({
    Key key,
    @required this.login,
    @required this.isViewer,
  }) : super(key: key);

  final String login;
  final bool isViewer;

  @override
  _UserOverviewState createState() => _UserOverviewState();
}

class _UserOverviewState extends State<UserOverview> with ProvidedState {
  GhGraphQLService ghGraphQLService;
  Future _user;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ghGraphQLService = Provider.of<GhGraphQLService>(context, listen: false);
    if (widget.isViewer) {
      _user = ghGraphQLService.getViewerComplex();
    } else {
      _user = ghGraphQLService.getUserComplex(widget.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<dynamic>(
          future: _user,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData && snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return FeedbackOnError(message: snapshot.error.toString());
            } else {
              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    automaticallyImplyLeading: false,
                    titleSpacing: 8,
                    title: Row(
                      children: [
                        AvatarBackButton(
                          avatar: snapshot.data['user']['avatarUrl'],
                          onPressed: () => Navigator.pop(context),
                        ),
                        SizedBox(width: 16),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              snapshot.data['user']['login'],
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            if (snapshot.data['user']['name'] != null)
                              Text(
                                snapshot.data['user']['name'],
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                          ],
                        ),
                      ],
                    ),
                    actions: [
                      ViewInBrowserButton(
                          url: 'https://github.com/${snapshot.data['user']['login']}'),
                      if (widget.isViewer)
                        IconButton(
                          icon: Icon(
                            MdiIcons.cogOutline,
                            color: context.colorScheme.secondary,
                          ),
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => SettingsScreen()),
                          ),
                        ),
                    ],
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate([
                      UserProfile(
                        currentUser: snapshot.data['user'],
                      ),
                    ]),
                  )
                ],
              );
            }
          }),
    );
  }
}
