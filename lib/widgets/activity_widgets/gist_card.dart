import 'package:flutter/material.dart';
import 'package:github_activity_feed/data/gist.dart';
import 'package:github_activity_feed/utils/extensions.dart';
import 'package:github_activity_feed/widgets/user_widgets/user_avatar.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';

class GistCard extends StatelessWidget {
  final Gist gist;

  const GistCard({
    Key key,
    this.gist,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Material(
        elevation: 2,
        color: context.isDarkTheme ? Colors.grey[900] : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: InkWell(
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          onTap: () => launch(gist.url),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                /// Owner avatar
                leading: GestureDetector(
                  onTap: () => launch(gist.owner.url),
                  child: UserAvatar(
                    avatarUrl: gist.owner.avatarUrl,
                    height: 44,
                    width: 44,
                  ),
                ),

                /// Owner with action
                title: Text(
                  '${gist.owner.login} created a gist',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),

                /// Gist file count
                subtitle: Text('Contains ${gist.files.length} files'),

                /// Fuzzy timestamp
                trailing:
                    Text(timeago.format(gist.createdAt, locale: 'en_short').replaceAll(' ', '')),
              ),

              /// Gist preview
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: context.isDarkTheme ? Colors.grey : Colors.black,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                          color: context.isDarkTheme
                              ? context.colorScheme.background
                              : Colors.grey, // update for light theme
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('${gist.description}'),
                            SizedBox(height: 8),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  MdiIcons.codeNotEqualVariant,
                                  size: 18,
                                  color: Colors.grey,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  '${gist.files.length} files',
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                                SizedBox(width: 16),
                                Icon(
                                  MdiIcons.commentMultiple,
                                  size: 18,
                                  color: Colors.grey,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  '${gist.commentCount} comments',
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                                SizedBox(width: 16),
                                Icon(
                                  MdiIcons.sourceFork,
                                  size: 18,
                                  color: Colors.grey,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  '${gist.forkCount} forks',
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
