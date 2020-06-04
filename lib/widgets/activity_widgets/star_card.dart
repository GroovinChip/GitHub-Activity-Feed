import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:github_activity_feed/data/activity_feed_models.dart';
import 'package:github_activity_feed/utils/extensions.dart';
import 'package:github_activity_feed/widgets/activity_widgets/starred_repo_preview.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';

class StarCard extends StatelessWidget {
  const StarCard({
    Key key,
    @required this.starredRepoEdge,
  }) : super(key: key);

  final StarredRepoEdge starredRepoEdge;

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
          onTap: () => launch(starredRepoEdge.star.url),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(starredRepoEdge.userActivity.userAvatarUrl),
                ),

                /// User with action
                title: Text(
                  '${starredRepoEdge.userActivity.userLogin} starred repository',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),

                /// Fuzzy timestamp
                subtitle: Text(timeago.format(starredRepoEdge.createdAt, locale: 'en')),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: StarredRepoPreview(
                  starredRepoEdge: starredRepoEdge,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
