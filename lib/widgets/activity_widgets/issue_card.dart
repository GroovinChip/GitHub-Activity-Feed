import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:github_activity_feed/data/activity_feed_models.dart';
import 'package:github_activity_feed/utils/extensions.dart';
import 'package:github_activity_feed/widgets/activity_widgets/issue_preview.dart';
import 'package:github_activity_feed/widgets/user_widgets/user_avatar.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';

class IssueCard extends StatelessWidget {
  const IssueCard({
    Key key,
    @required this.issue,
  }) : super(key: key);

  final Issue issue;

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
          onTap: () => launch(issue.url),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                /// User avatar
                leading: GestureDetector(
                  onTap: () => launch(issue.author.url),
                  child: UserAvatar(
                    avatarUrl: issue.author.avatarUrl,
                    height: 44,
                    width: 44,
                  ),
                ),

                /// User with action
                title: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '${issue.author.login} opened issue',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),

                /// Repository with issue number
                subtitle: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      MdiIcons.alertCircleOutline,
                      color: !issue.closed ? Colors.green : Colors.red,
                      size: 16,
                    ),
                    SizedBox(width: 4),
                    Expanded(
                      child: FittedBox(
                        alignment: Alignment.topLeft,
                        fit: BoxFit.scaleDown,
                        child: Text(
                          '${issue.repository.nameWithOwner} #${issue.number}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                /// Fuzzy timestamp
                trailing: Text(
                  timeago.format(issue.createdAt, locale: 'en_short').replaceAll(' ', ''),
                ),
              ),

              /// Issue preview
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: IssuePreview(
                  issue: issue,
                  isComment: false,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
