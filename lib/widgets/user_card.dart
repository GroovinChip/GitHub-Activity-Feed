import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:timeago/timeago.dart' as timeago;

class UserCard extends StatelessWidget {
  const UserCard({
    Key key,
    @required this.user,
  }) : super(key: key);

  final dynamic user;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.network(
                  user['avatarUrl'],
                  width: 50,
                  height: 50,
                ),
              ),
            ],
          ),
          SizedBox(width: 8),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.person_outline, size: 16),
                  SizedBox(width: 4),
                  Text('${user['login']}${user['name'] != null ? ' (${user['name']})' : ''}'),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.access_time, size: 16),
                  SizedBox(width: 4),
                  Text('${user['createdAt'] != null ? 'joined GitHub ${timeago.format(DateTime.parse(user['createdAt']), locale: 'en_short')} ago' : ''}'),
                ],
              ),
              if (user['email'] != '')
                Row(
                  children: [
                    Icon(Icons.mail_outline, size: 16),
                    SizedBox(width: 4),
                    Text(user['email']),
                  ],
                ),
              SizedBox(height: 16),
            ],
          ),
        ],
      ),
      /*child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Image.network(
            user['avatarUrl'],
            width: 50,
            height: 50,
          ),
        ),
        title: Text(
          user['login'],
          style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
        ),
        subtitle: user['name'] != null ? Text(user['name']) : null,
        trailing: RaisedButton.icon(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          color: Theme.of(context).primaryColor,
          icon: Icon(
            user['viewerIsFollowing'] ? MdiIcons.accountMinusOutline : MdiIcons.accountPlusOutline,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          label: Text(
            user['viewerIsFollowing'] ? 'Unfollow' : 'Follow',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          onPressed: () {},
        ),
        onTap: () => launch(user['url']),
      ),*/
    );
  }
}
