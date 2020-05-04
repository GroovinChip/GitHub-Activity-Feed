import 'package:flutter/material.dart';
import 'package:github_activity_feed/app/provided.dart';
import 'package:github_activity_feed/services/extensions.dart';
import 'package:groovin_widgets/avatar_back_button.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

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
            Text(
              user.login,
              style: TextStyle(fontWeight: FontWeight.bold),
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
          ListView(
            children: [
              Row(
                children: [
                  Icon(Icons.link),
                  SizedBox(width: 8),
                  Text(user.blog, style: TextStyle(color: textColor)),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.location_on),
                  SizedBox(width: 8),
                  Text(user.location, style: TextStyle(color: textColor)),
                ],
              ),
              Text(
                '${user.ownedPrivateReposCount} pinned repositories',
                style: TextStyle(color: textColor),
              ),
            ],
          ),
          Container(),
          Container(),
          Container(),
        ],
      ),
    );
  }
}
