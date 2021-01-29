import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:github_activity_feed/app/provided.dart';
import 'package:github_activity_feed/screens/search_screen.dart';
import 'package:github_activity_feed/state/prefs_bloc.dart';
import 'package:github_activity_feed/utils/extensions.dart';
import 'package:github_activity_feed/widgets/activity_widgets/activity_feed.dart';
import 'package:github_activity_feed/widgets/fade_indexed_stack.dart';
import 'package:github_activity_feed/widgets/menu_sheet_content.dart';
import 'package:github_activity_feed/widgets/octicons/oct_icons24_icons.dart';
import 'package:github_activity_feed/widgets/user_widgets/following_users.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = Navigator.defaultRouteName;

  static Route<dynamic> route({
    RouteSettings settings = const RouteSettings(name: routeName),
  }) {
    return MaterialPageRoute(
      settings: settings,
      builder: (BuildContext context) {
        return HomeScreen();
      },
    );
  }

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with ProvidedState {
  PrefsBloc prefsbloc;
  int _currentIndex = 0;
  final List<Widget> titles = [
    Text('Activity Feed'),
    Text('You Follow'),
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    prefsbloc = Provider.of<PrefsBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkResponse(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: CircleAvatar(
              backgroundImage: NetworkImage(currentUser.avatarUrl),
            ),
          ),
          onTap: () => showModalBottomSheet(
            context: context,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            builder: (_) => MenuSheetContent(),
          ),
        ),
        title: DefaultTextStyle(
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: context.isDarkTheme ? Colors.white : Colors.black,
          ),
          child: titles[_currentIndex],
        ),
        actions: [
          StreamBuilder<bool>(
            stream: prefsbloc.cardOrTileSubject,
            initialData: prefsbloc.cardOrTileSubject.value,
            builder: (context, snapshot) {
              return IconButton(
                icon: Icon(
                  Icons.search,
                  color: context.isDarkTheme ? Colors.white : Colors.black,
                ),
                onPressed: () => showSearch(
                  context: context,
                  delegate: SearchScreen(
                    gitHub: githubService.github,
                    showCardsOrTiles: snapshot.data,
                  ),
                ).catchError((error, stackTrace) {
                  print(error);
                  FirebaseCrashlytics.instance.recordError(
                    error,
                    stackTrace,
                    reason: 'Crashed when opening search',
                  );
                }),
              );
            },
          ),
        ],
      ),
      body: FadeIndexedStack(
        index: _currentIndex,
        duration: Duration(milliseconds: 100),
        children: [
          ActivityFeed(),
          ViewerFollowingList(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(OctIcons24.pulse_24),
            label: 'Feed',
          ),
          //todo: contribute group icons to octicons package
          BottomNavigationBarItem(
            icon: Icon(OctIcons24.people_24),
            label: '${currentUser.followingCount} Following',
          ),
        ],
      ),
    );
  }
}
