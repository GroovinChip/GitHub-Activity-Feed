import 'package:flutter/material.dart';
import 'package:github_activity_feed/data/trending_repositories.dart';
import 'package:github_activity_feed/utils/color_from_string.dart';
import 'package:github_activity_feed/utils/extensions.dart';
import 'package:github_activity_feed/widgets/user_widgets/user_avatar.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class TrendingRepositoryCard extends StatelessWidget {
  const TrendingRepositoryCard({
    Key key,
    @required this.repo,
  }) : super(key: key);

  final TrendingRepository repo;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 225,
      width: 275,
      child: Card(
        color: context.isDarkTheme ? Colors.grey.shade900 : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: InkWell(
          onTap: () => launch(repo.url),
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      UserAvatar(
                        height: 44,
                        width: 44,
                        avatarUrl: repo.avatar,
                      ),
                      SizedBox(width: 16),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            repo.author,
                            style: TextStyle(
                              fontSize: 18,
                              color: context.isDarkTheme ? Colors.grey : Colors.grey.shade800,
                            ),
                          ),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              repo.name,
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    repo.description,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Expanded(
                  child: Container(),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 6.0),
                  child: Row(
                    children: [
                      StarIndicator(
                        starCount: repo.stars,
                      ),
                      SizedBox(width: 8),
                      if (repo.languageColor != null)
                        LanguageIndicator(
                          languageColor: repo.languageColor,
                          language: repo.language,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class StarIndicator extends StatelessWidget {
  const StarIndicator({
    Key key,
    @required this.starCount,
  }) : super(key: key);

  final int starCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.star,
          color: Colors.yellow,
        ),
        SizedBox(width: 4),
        Text('$starCount'),
      ],
    );
  }
}

class LanguageIndicator extends StatelessWidget {
  const LanguageIndicator({
    Key key,
    @required this.languageColor,
    @required this.language,
  }) : super(key: key);

  final String languageColor;
  final String language;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          MdiIcons.circle,
          color: HexColor(languageColor),
        ),
        SizedBox(width: 4),
        Text(language),
      ],
    );
  }
}
