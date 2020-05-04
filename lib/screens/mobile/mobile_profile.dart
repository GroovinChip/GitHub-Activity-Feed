import 'package:flutter/material.dart';
import 'package:github/github.dart';
import 'package:github_activity_feed/app/provided.dart';
import 'package:github_activity_feed/services/extensions.dart';
import 'package:groovin_widgets/avatar_back_button.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:rxdart/rxdart.dart';

class MobileProfile extends StatefulWidget {
  MobileProfile({Key key}) : super(key: key);

  @override
  _MobileProfileState createState() => _MobileProfileState();
}

class _MobileProfileState extends State<MobileProfile>
    with ProvidedState, SingleTickerProviderStateMixin {
  TabController _tabController;
  Color textColor;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(initialIndex: 0, length: 4, vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (context.isDarkTheme) {
      textColor = Colors.white;
    } else {
      textColor = Colors.black;
    }
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
        backgroundColor: context.brightness == Brightness.light
            ? context.primaryColor
            : context.primaryColorDark,
        titleSpacing: 8,
        title: Row(
          children: [
            AvatarBackButton(
              avatar: user.avatarUrl,
              onPressed: () => Navigator.pop(context),
            ),
            SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.login,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  user.name,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              MdiIcons.cogOutline,
              color: context.accentColor,
            ),
            onPressed: () {},
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: context.accentColor,
          isScrollable: true,
          tabs: [
            Tab(text: 'Overview'),
            Tab(text: 'Repositories (${user.publicReposCount + user.privateReposCount})'),
            Tab(text: 'Following (${user.followingCount})'),
            Tab(text: 'Followers (${user.followersCount})'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          StreamBuilder(
            stream: CombineLatestStream.combine2(
              github.github.organizations.list().toList().asStream(),
              github.github.activity.listStarred().toList().asStream(),
              (List<Organization> a, List<Repository> b) => [a, b],
            ),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              } else {
                List<Organization> _organizations = snapshot.data[0];
                List<Repository> _starred = snapshot.data[1];
                return ListView(
                  children: [
                    ListTile(
                      title: Text(user.bio, style: TextStyle(color: textColor)),
                    ),
                    ListTile(
                      leading: Icon(MdiIcons.mapMarkerOutline),
                      title: Text(user.location, style: TextStyle(color: textColor)),
                    ),
                    ListTile(
                      leading: Icon(MdiIcons.emailOutline),
                      title: Text(user.email, style: TextStyle(color: textColor)),
                    ),
                    ListTile(
                      leading: Icon(Icons.link),
                      title: Text(user.blog, style: TextStyle(color: textColor)),
                    ),
                    ListTile(
                      leading: Icon(Icons.access_time),
                      title: Text(user.createdAt.toString(), style: TextStyle(color: textColor)),
                    ),
                    /*Text(
                '${user.ownedPrivateReposCount} pinned repositories',
                style: TextStyle(color: textColor),
              ),*/
                    Divider(height: 0),
                    ListTile(
                      title: Text('Organizations', style: TextStyle(color: textColor)),
                      trailing: Text(
                        '${_organizations.length}',
                        style: TextStyle(color: textColor),
                      ),
                      onTap: () {},
                    ),
                    ListTile(
                      title: Text('Starred', style: TextStyle(color: textColor)),
                      trailing: Text(
                        '${_starred.length}',
                        style: TextStyle(color: textColor),
                      ),
                      onTap: () {},
                    ),
                  ],
                );
              }
            },
          ),
          Container(),
          Container(),
          Container(),
        ],
      ),
    );
  }
}
