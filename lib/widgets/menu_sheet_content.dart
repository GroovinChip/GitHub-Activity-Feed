import 'package:flutter/material.dart';
import 'package:github_activity_feed/app/provided.dart';
import 'package:github_activity_feed/state/prefs_bloc.dart';
import 'package:github_activity_feed/utils/extensions.dart';
import 'package:github_activity_feed/widgets/dialogs/logout_dialog.dart';
import 'package:github_activity_feed/widgets/dialogs/theme_switcher_dialog.dart';
import 'package:groovin_widgets/groovin_widgets.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:wiredash/wiredash.dart';

class MenuSheetContent extends StatefulWidget {
  @override
  _MenuSheetContentState createState() => _MenuSheetContentState();
}

class _MenuSheetContentState extends State<MenuSheetContent>
    with ProvidedState {
  PackageInfo _packageInfo;
  PrefsBloc prefsbloc;

  @override
  void initState() {
    super.initState();
    getPackageInfo();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    prefsbloc = Provider.of<PrefsBloc>(context);
  }

  void getPackageInfo() {
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      setState(() => _packageInfo = packageInfo);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ModalDrawerHandle(),
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(user.avatarUrl),
            ),
            title: Text(user.login),
            subtitle: Text(user.email ?? user.login),
            trailing: OutlinedButton(
              style: OutlinedButton.styleFrom(
                shape: StadiumBorder(),
                side: BorderSide(
                  color: context.isDarkTheme ? Colors.white : Colors.black,
                ),
              ),
              child: Text(
                'Log out',
                style: TextStyle(
                  color: context.isDarkTheme ? Colors.white : Colors.black,
                ),
              ),
              onPressed: () => showDialog(
                context: context,
                builder: (_) => LogOutDialog(
                  githubService: githubService,
                ),
              ),
            ),
          ),
          StreamBuilder<ThemeMode>(
            stream: prefsbloc.themeModeSubject,
            initialData: prefsbloc.themeModeSubject.value,
            builder: (BuildContext context, AsyncSnapshot<ThemeMode> snapshot) {
              return ListTile(
                title: Text("Change app theme"),
                subtitle: Text(snapshot.data.format()),
                onTap: () => showDialog(
                  context: context,
                  builder: (_) => ThemeSwitcherDialog(
                    themeMode: snapshot.data,
                  ),
                ),
              );
            },
          ),
          StreamBuilder<bool>(
            stream: prefsbloc.cardOrTileSubject,
            initialData: prefsbloc.cardOrTileSubject.value,
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              return SwitchListTile.adaptive(
                value: snapshot.data,
                onChanged: (bool) {
                  prefsbloc.setCardOrTilePref(bool);
                  setState(() {});
                },
                activeColor: Theme.of(context).primaryColor,
                title: Text(
                  snapshot.data == true ? 'Switch to tiles' : 'Switch to cards',
                ),
                subtitle: Text(snapshot.data == true
                    ? 'Show users as tiles instead of cards'
                    : 'Show users as cards instead of tiles'),
              );
            },
          ),
          Divider(height: 0.0),
          ListTile(
            title: Text('GitHub Activity Feed'),
            subtitle: Text('Version ${_packageInfo?.version}'),
          ),
          ListTile(
            title: Text('Share feedback'),
            onTap: () {
              Navigator.pop(context);
              Wiredash.of(context).show();
            },
          ),
        ],
      ),
    );
  }
}
