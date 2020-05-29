import 'package:flutter/material.dart';
import 'package:github_activity_feed/data/activity_feed_models.dart';
import 'package:github_activity_feed/utils/extensions.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';

class StarCard extends StatelessWidget {
  const StarCard({
    Key key,
    this.user,
    @required this.star,
    @required this.starredAt,
  }) : super(key: key);

  final String user;
  final Star star;
  final String starredAt;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Material(
        elevation: 2,
        color: context.isDarkTheme ? Colors.grey[800] : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: InkWell(
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          onTap: () => launch(star.url),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ListTile(
                leading: CircleAvatar(),

                /// user(??) with action
                title: Text(
                  '___ starred repository',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),

                /// repository with issue number
                subtitle: Text(star.nameWithOwner),

                /// fuzzy timestamp
                trailing: Text(timeago.format(DateTime.parse(starredAt), locale: 'en_short').replaceAll(' ', '')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
