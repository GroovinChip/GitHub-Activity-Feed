import 'package:flutter/material.dart';
import 'package:github_activity_feed/app/provided.dart';
import 'package:github_activity_feed/services/extensions.dart';
import 'package:github_activity_feed/screens/widgets/following_feed.dart';
import 'package:github_activity_feed/screens/widgets/personal_feed.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class MobileActivityFeed extends StatefulWidget {
  @override
  _MobileActivityFeedState createState() => _MobileActivityFeedState();
}

class _MobileActivityFeedState extends State<MobileActivityFeed> with ProvidedState {
  int _pageIndex = 0;
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _pageIndex, keepPage: true);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.brightness == Brightness.light
            ? context.primaryColor
            : context.primaryColorDark,
        leading: InkResponse(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                user.avatarUrl,
              ),
            ),
          ),
          onTap: () {},
        ),
        title: Text(
          'Activity Feed',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) => setState(() => _pageIndex = index),
        children: [
          FollowingFeed(),
          PersonalFeed(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _pageIndex,
        onTap: (index) {
          setState(() => _pageIndex = index);
          _pageController.animateToPage(
            _pageIndex,
            duration: Duration(milliseconds: 500),
            curve: Curves.easeOutCubic,
          );
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(MdiIcons.github),
            title: Text('Following'),
          ),
          BottomNavigationBarItem(
            icon: Icon(MdiIcons.accountTieOutline),
            title: Text('Personal'),
          ),
        ],
      ),
    );
  }
}
