import 'package:flutter/material.dart';
import 'package:wiredash/wiredash.dart';

class ReportBugButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RaisedButton.icon(
      color: Colors.red,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      icon: Icon(Icons.bug_report),
      label: Text('Report'),
      onPressed: () => Wiredash.of(context).show(),
    );
  }
}
