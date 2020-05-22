import 'package:flutter/material.dart';
import 'package:github/github.dart';
import 'package:github_activity_feed/utils/prettyJson.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class PullRequestStatusLabel extends StatefulWidget {
  const PullRequestStatusLabel({
    Key key,
    @required this.state,
    @required this.merged,
    @required this.draft,
  }) : super(key: key);

  final String state;
  final bool merged;
  final bool draft;

  @override
  _PullRequestStatusLabelState createState() => _PullRequestStatusLabelState();
}

class _PullRequestStatusLabelState extends State<PullRequestStatusLabel> {
  Color labelColor;
  String label;

  @override
  void initState() {
    super.initState();
    //printPrettyJson(widget.pullRequest.toJson());
    if (widget.draft) {
      labelColor = Colors.grey.withOpacity(0.5);
      label = 'Draft';
    } else if (!widget.merged) {
      switch (widget.state) {
        case 'open':
          labelColor = Colors.green;
          label = 'Open';
          break;
        case 'closed':
          labelColor = Colors.red;
          label = 'Closed';
          break;
        default:
          break;
      }
    } else if (widget.merged) {
      labelColor = Colors.deepPurple[700];
      label = 'Merged';
    } else {
      labelColor = Colors.deepPurple[700];
      label = 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: labelColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(6, 2, 6, 2),
        child: Row(
          children: [
            Icon(MdiIcons.sourcePull, size: 20),
            SizedBox(width: 4),
            Text(
              label,
              style: GoogleFonts.firaCode(),
            ),
          ],
        ),
      ),
    );
  }
}
