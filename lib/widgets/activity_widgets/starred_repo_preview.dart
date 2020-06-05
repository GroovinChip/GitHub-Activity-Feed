import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:github_activity_feed/data/activity_feed_models.dart';
import 'package:github_activity_feed/utils/color_from_string.dart';
import 'package:github_activity_feed/utils/extensions.dart';
import 'package:github_activity_feed/widgets/user_widgets/user_avatar.dart';

class StarredRepoPreview extends StatelessWidget {
  final StarredRepoEdge starredRepoEdge;

  const StarredRepoPreview({
    Key key,
    @required this.starredRepoEdge,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              border: Border.all(
                color: context.isDarkTheme ? Colors.grey : Colors.black,
              ),
              borderRadius: BorderRadius.circular(8.0),
              color: context.isDarkTheme ? context.colorScheme.background : Colors.grey, // update for light theme
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    UserAvatar(
                      avatarUrl: starredRepoEdge.star.owner.avatarUrl,
                      height: 30,
                      width: 30,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        starredRepoEdge.star.nameWithOwner,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  starredRepoEdge.star.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                Row(
                  children: [
                    Chip(
                      label: Text(starredRepoEdge.star.languages.first.name),
                      backgroundColor: HexColor(
                        starredRepoEdge.star.languages.first.color,
                      ),
                    ),
                    SizedBox(width: 16),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.star_border,
                          size: 22,
                          color: Colors.grey,
                        ),
                        SizedBox(width: 4),
                        Text(
                          '${starredRepoEdge.star.stargazers.totalCount}',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),

                    // todo: if viewer has not starred this repo, show a star button?
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
