import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

/// A user avatar widget that is square with rounded corners to better
/// match GitHub's styling in their own mobile app
class UserAvatar extends StatelessWidget {
  const UserAvatar({
    Key key,
    @required this.avatarUrl,
    @required this.height,
    @required this.width,
    this.userUrl,
  }) : super(key: key);

  final String avatarUrl;
  final double height;
  final double width;
  final String userUrl;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Material(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        color: Colors.grey.shade200, // neat!
        child: Ink.image(
          //todo: use cached_network_image package
          image: NetworkImage(avatarUrl ?? 'https://avatars1.githubusercontent.com/u/5868834?s=400&v=4'),
          fit: BoxFit.cover,
          height: height,
          width: width,
          child: userUrl != null ? InkWell(
            onTap: () => url_launcher.launch(userUrl),
          ) : null,
        ),
      ),
    );
  }
}
