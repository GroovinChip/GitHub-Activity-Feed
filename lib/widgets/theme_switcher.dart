import 'package:flutter/material.dart';
import 'package:github_activity_feed/state/prefs_bloc.dart';
import 'package:provider/provider.dart';

class ThemeSwitcher extends StatefulWidget {
  ThemeSwitcher({
    Key key,
    this.themeMode,
  }) : super(key: key);

  final ThemeMode themeMode;

  @override
  _ThemeSwitcherState createState() => _ThemeSwitcherState();
}

class _ThemeSwitcherState extends State<ThemeSwitcher> {
  PrefsBloc prefsbloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    prefsbloc = Provider.of<PrefsBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      backgroundColor: Theme.of(context).canvasColor,
      title: Text('Change app theme'),
      children: [
        RadioListTile(
          title: Text('System theme'),
          value: ThemeMode.system,
          selected: widget.themeMode == ThemeMode.system ? true : false,
          groupValue: widget.themeMode,
          onChanged: (themeMode) {
            prefsbloc.setThemeModePref(themeMode);
            setState(() {});
            Navigator.pop(context);
          },
        ),
        RadioListTile(
          title: Text('Light theme'),
          value: ThemeMode.light,
          selected: widget.themeMode == ThemeMode.light ? true : false,
          groupValue: widget.themeMode,
          onChanged: (themeMode) {
            prefsbloc.setThemeModePref(themeMode);
            setState(() {});
            Navigator.pop(context);
          },
        ),
        RadioListTile(
          title: Text('Dark theme'),
          value: ThemeMode.dark,
          selected: widget.themeMode == ThemeMode.dark ? true : false,
          groupValue: widget.themeMode,
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
