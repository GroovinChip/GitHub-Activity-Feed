import 'package:flutter/material.dart';
import 'package:github_activity_feed/data/custom_repos.dart';
import 'package:github_activity_feed/widgets/activity_widgets/count_item.dart';
import 'package:github_activity_feed/widgets/activity_widgets/language_icon.dart';
import 'package:github_activity_feed/widgets/user_widgets/user_avatar.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class RepoPreview extends StatelessWidget {
  const RepoPreview({
    Key key,
    @required this.avatarUrl,
    @required this.repoName,
    @required this.repoDescription,
    @required this.watcherCount,
    @required this.stargazerCount,
    @required this.forkCount,
    @required this.primaryLanguage,
  }) : super(key: key);

  final String avatarUrl;
  final String repoName;
  final String repoDescription;
  final int watcherCount;
  final int stargazerCount;
  final int forkCount;
  final Language primaryLanguage;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserAvatar(
              avatarUrl: avatarUrl,
              height: 25,
              width: 25,
            ),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                repoName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Text(repoDescription ?? 'No description'),
        SizedBox(height: 8),
        Row(
          children: [
            CountItem(
              iconData: Icons.remove_red_eye_outlined,
              countItem: watcherCount,
            ),
            SizedBox(width: 16),
            CountItem(
              iconData: Icons.star_outline,
              countItem: stargazerCount,
            ),
            SizedBox(width: 16),
            CountItem(
              iconData: MdiIcons.sourceFork,
              countItem: forkCount,
            ),
            Spacer(),
            LanguageIcon(
              language: primaryLanguage,
            ),
          ],
        ),
      ],
    );
  }
}
