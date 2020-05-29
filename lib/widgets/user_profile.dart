import 'package:flutter/material.dart';
import 'package:github_activity_feed/services/gh_gql_query_service.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({
    Key key,
    @required this.currentUser,
  }) : super(key: key);

  final dynamic currentUser;

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  dynamic get currentUser => widget.currentUser;

  @override
  Widget build(BuildContext context) {
    final ghGraphQLService = Provider.of<GhGraphQLService>(context, listen: false);
    return SingleChildScrollView(
      child: Column(
        children: [
          if (!currentUser['isViewer'])
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Row(
                children: [
                  Expanded(
                    child: RaisedButton.icon(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      icon: Icon(!currentUser['isViewer']
                          ? MdiIcons.accountPlusOutline
                          : MdiIcons.accountMinusOutline),
                      label: Text(!currentUser['isViewer'] ? 'Follow' : 'Unfollow'),
                      onPressed: () {
                        if (currentUser['isViewer']) {
                          setState(() => ghGraphQLService.unfollowUser(currentUser['login']));
                        } else {
                          setState(() => ghGraphQLService.followUser(currentUser['login']));
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _ProfileEntry extends StatelessWidget {
  final String name;
  final int count;

  const _ProfileEntry({
    Key key,
    this.name,
    this.count,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name),
          count == null ? Text('...') : Text('$count'),
        ],
      ),
    );
  }
}
