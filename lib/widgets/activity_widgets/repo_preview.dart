import 'package:flutter/material.dart';
import 'package:github_activity_feed/data/custom_repos.dart';
import 'package:github_activity_feed/widgets/activity_widgets/count_item.dart';
import 'package:github_activity_feed/widgets/activity_widgets/language_icon.dart';
import 'package:github_activity_feed/widgets/octicons/oct_icons16_icons.dart';
import 'package:github_activity_feed/widgets/user_widgets/user_avatar.dart';

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
              iconData: OctIcons16.eye_16,
              countItem: watcherCount,
            ),
            SizedBox(width: 12),
            CountItem(
              iconData: OctIcons16.star_16,
              countItem: stargazerCount,
            ),
            SizedBox(width: 12),
            CountItem(
              iconData: OctIcons16.repo_forked_16,
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
