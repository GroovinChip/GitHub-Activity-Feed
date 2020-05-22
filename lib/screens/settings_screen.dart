import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:github_activity_feed/app/provided.dart';
import 'package:github_activity_feed/services/extensions.dart';
import 'package:wiredash/wiredash.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen({Key key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> with ProvidedState {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text(
              'General',
              style: TextStyle(color: Theme.of(context).accentColor),
            ),
          ),
          /*ListTile(
            title: Text('Theme'),
            subtitle: Text('value'),
            onTap: () => showDialog(
              context: context,
              builder: (_) => SimpleDialog(
                title: Text(
                  'Theme',
                  style: TextStyle(color: context.colorScheme.onBackground),
                ),
                children: [
                  RadioListTile(
                    value: '',
                    onChanged: (value) {},
                    title: Text(
                      'Light',
                      style: TextStyle(color: context.colorScheme.onBackground),
                    ),
                    groupValue: false,
                    activeColor: context.colorScheme.secondary,
                  ),
                  RadioListTile(
                    value: '',
                    onChanged: (value) {},
                    title: Text(
                      'Dark',
                      style: TextStyle(color: context.colorScheme.onBackground),
                    ),
                    groupValue: false,
                    activeColor: context.colorScheme.secondary,
                  ),
                  RadioListTile(
                    value: true,
                    onChanged: (value) {},
                    title: Text(
                      'System',
                      style: TextStyle(color: context.colorScheme.onBackground),
                    ),
                    groupValue: true,
                    activeColor: context.colorScheme.secondary,
                  ),
                ],
              ),
            ),
          ),*/
          ListTile(
            title: Text('Share feedback'),
            onTap: () => Wiredash.of(context).show(),
          ),
          ListTile(
            title: Text('Log out'),
            onTap: () => showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: Text(
                  'Log out',
                  style: TextStyle(
                    color: context.colorScheme.onBackground,
                  ),
                ),
                content: Text(
                  'Would you like to log out?',
                  style: TextStyle(
                    color: context.colorScheme.onBackground,
                  ),
                ),
                actions: [
                  FlatButton(
                    textColor: context.colorScheme.onBackground,
                    child: Text('Cancel'),
                    onPressed: () => Navigator.pop(context),
                  ),
                  FlatButton(
                    child: Text('Yes'),
                    onPressed: () => githubService.logOut(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
