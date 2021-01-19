import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:github_activity_feed/data/base_user.dart';
import 'package:github_activity_feed/theme/github_colors.dart';
import 'package:github_activity_feed/utils/extensions.dart';
import 'package:github_activity_feed/utils/printers.dart';
import 'package:github_activity_feed/widgets/user_widgets/user_avatar.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

/// A card that represents a User, with more detail than [UserTile]
class UserCard extends StatelessWidget {
  final BaseUser user;

  const UserCard({
    Key key,
    @required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.isDarkTheme ? GhColors.grey.shade800 : Colors.white,
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: () => url_launcher.launch(user.url),
        onLongPress: () => printFormattedBaseUser(user),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 8.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  UserAvatar(
                    avatarUrl: user.avatarUrl,
                    height: 44,
                    width: 44,
                  ),
                  if (user.viewerIsFollowing != null)
                    !user.viewerIsFollowing
                        ? IconButton(
                            icon: Icon(MdiIcons.accountPlusOutline),
                            onPressed: () {},
                          )
                        : Container(),
                ],
              ),
            ),
            DefaultTextStyle.merge(
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: user.name != null
                    ? Text(
                        user.name,
                        maxLines: 1,
                      )
                    : Text(
                        '@${user.login}',
                        maxLines: 1,
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: Text(
                user.name != null ? '@${user.login}' : '',
                maxLines: 1,
                style: TextStyle(
                  color: context.isDarkTheme
                      ? GhColors.grey.shade300
                      : Colors.grey.shade800,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(7, 4, 8, 0),
              child: Row(
                children: [
                  Icon(
                    MdiIcons.mapMarkerOutline,
                    size: 12,
                    color: context.isDarkTheme
                        ? GhColors.grey.shade300
                        : Colors.grey.shade800,
                  ),
                  Expanded(
                    child: Text(
                      user.location ?? '[no location]',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: context.isDarkTheme
                            ? GhColors.grey.shade300
                            : Colors.grey.shade800,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
                child: Text(
                  user.bio == null || user.bio == '' ? '[No bio]' : user.bio,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
              ),
            ),

            // maybe something about contribution activity?
          ],
        ),
      ),
    );
  }
}
