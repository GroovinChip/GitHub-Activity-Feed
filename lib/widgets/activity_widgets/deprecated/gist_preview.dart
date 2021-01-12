import 'package:flutter/material.dart';
import 'package:github_activity_feed/data/gist.dart';
import 'package:github_activity_feed/utils/extensions.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

@deprecated
class GistPreview extends StatelessWidget {
  const GistPreview({
    Key key,
    @required this.gist,
  }) : super(key: key);

  final Gist gist;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
              ),
              borderRadius: BorderRadius.circular(8.0),
              color: context.isDarkTheme ? context.colorScheme.background : Colors.white, // update for light theme
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${gist.description != '' ? gist.description : ['No description']}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      MdiIcons.codeNotEqualVariant,
                      size: 18,
                      color: context.isDarkTheme ? Colors.grey : Colors.grey.shade800,
                    ),
                    SizedBox(width: 4),
                    Text(
                      '${gist.files.length} files',
                      style: TextStyle(
                        color: context.isDarkTheme ? Colors.grey : Colors.grey.shade800,
                      ),
                    ),
                    SizedBox(width: 16),
                    Icon(
                      MdiIcons.commentMultiple,
                      size: 18,
                      color: context.isDarkTheme ? Colors.grey : Colors.grey.shade800,
                    ),
                    SizedBox(width: 4),
                    Text(
                      '${gist.commentCount} comments',
                      style: TextStyle(
                        color: context.isDarkTheme ? Colors.grey : Colors.grey.shade800,
                      ),
                    ),
                    SizedBox(width: 16),
                    Icon(
                      MdiIcons.sourceFork,
                      size: 18,
                      color: context.isDarkTheme ? Colors.grey : Colors.grey.shade800,
                    ),
                    SizedBox(width: 4),
                    Text(
                      '${gist.forkCount} forks',
                      style: TextStyle(
                        color: context.isDarkTheme ? Colors.grey : Colors.grey.shade800,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
