import 'package:flutter/material.dart';
import 'package:github_activity_feed/app/provided.dart';
import 'package:github_activity_feed/widgets/log_out_confirm_dialog.dart';
import 'package:groovin_widgets/modal_drawer_handle.dart';
import 'package:wiredash/wiredash.dart';

class MenuBottomSheetContent extends StatefulWidget {

  @override
  _MenuBottomSheetContentState createState() => _MenuBottomSheetContentState();
}

class _MenuBottomSheetContentState extends State<MenuBottomSheetContent> with ProvidedState {
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
        Divider(height: 0.0),
        ListTile(
          title: Text('Share feedback'),
          onTap: () {
            Navigator.pop(context);
            Wiredash.of(context).show();
          },
        ),
      ],
    );
  }
}
