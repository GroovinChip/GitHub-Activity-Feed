import 'package:flutter/material.dart';
import 'package:github_activity_feed/app/provided.dart';
import 'package:github_activity_feed/state/prefs_bloc.dart';
import 'package:github_activity_feed/widgets/log_out_confirm_dialog.dart';
import 'package:groovin_widgets/modal_drawer_handle.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:wiredash/wiredash.dart';

class MenuBottomSheetContent extends StatefulWidget {
  @override
  _MenuBottomSheetContentState createState() => _MenuBottomSheetContentState();
}

class _MenuBottomSheetContentState extends State<MenuBottomSheetContent> with ProvidedState {
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
    return Column(
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
          trailing: FlatButton(
            child: Text('Log out'),
            onPressed: () => showDialog(
              context: context,
              builder: (_) => LogOutConfirmDialog(
                githubService: githubService,
              ),
            ),
          ),
        ),
        StreamBuilder<bool>(
          stream: prefsbloc.userCardOrTile,
          initialData: prefsbloc.userCardOrTile.value,
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            return SwitchListTile(
              value: snapshot.data,
              onChanged: (bool) {
                setState(() {
                  prefsbloc.setUserCardPrefs(bool);
                });
              },
              activeColor: Theme.of(context).accentColor,
              title: Text(snapshot.data == true ? 'Switch to tiles' : 'Switch to cards'),
              subtitle: Text(snapshot.data == true ? 'Show users as tiles instead of cards' : 'Show users as cards instead of tiles'),
            );
          },
        ),
        Divider(height: 0.0),
        ListTile(
          title: Text('Share feedback'),
          onTap: () {
            Navigator.pop(context);
            Wiredash.of(context).show();
          },
        ),
        ListTile(
          title: Text('Version ${_packageInfo?.version}'),
        ),
      ],
    );
  }
}
