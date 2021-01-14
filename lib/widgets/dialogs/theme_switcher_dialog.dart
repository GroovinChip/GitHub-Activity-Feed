import 'package:flutter/material.dart';
import 'package:github_activity_feed/state/prefs_bloc.dart';
import 'package:github_activity_feed/utils/extensions.dart';
import 'package:provider/provider.dart';

class ThemeSwitcherDialog extends StatefulWidget {
  ThemeSwitcherDialog({
    Key key,
    this.themeMode,
  }) : super(key: key);

  final ThemeMode themeMode;

  @override
  _ThemeSwitcherDialogState createState() => _ThemeSwitcherDialogState();
}

class _ThemeSwitcherDialogState extends State<ThemeSwitcherDialog> {
  PrefsBloc prefsbloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    prefsbloc = Provider.of<PrefsBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text('Change app theme'),
      children: [
        RadioListTile(
          title: Text('System theme'),
          value: ThemeMode.system,
          selected: widget.themeMode.isSystemMode,
          groupValue: widget.themeMode,
          activeColor: Theme.of(context).accentColor,
          onChanged: (themeMode) {
            prefsbloc.setThemeModePref(themeMode);
            setState(() {});
            Navigator.pop(context);
          },
        ),
        RadioListTile(
          title: Text('Light theme'),
          value: ThemeMode.light,
          selected: widget.themeMode.isLightMode,
          groupValue: widget.themeMode,
          activeColor: Theme.of(context).accentColor,
          onChanged: (themeMode) {
            prefsbloc.setThemeModePref(themeMode);
            setState(() {});
            Navigator.pop(context);
          },
        ),
        RadioListTile(
          title: Text('Dark theme'),
          value: ThemeMode.dark,
          selected: widget.themeMode.isDarkMode,
          groupValue: widget.themeMode,
          activeColor: Theme.of(context).accentColor,
          onChanged: (themeMode) {
            prefsbloc.setThemeModePref(themeMode);
            setState(() {});
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
