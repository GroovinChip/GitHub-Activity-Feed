import 'package:flutter/material.dart';

/// A user avatar widget that is square with rounded corners to better
/// match GitHub's styling in their own mobile app
class UserAvatar extends StatelessWidget {
  const UserAvatar({
    Key key,
    @required this.avatarUrl,
    @required this.height,
    @required this.width,
  }) : super(key: key);

  final String avatarUrl;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        color: Colors.grey.shade200, // neat!
        child: Image.network(
          avatarUrl ?? 'https://avatars1.githubusercontent.com/u/5868834?s=400&v=4',
          height: height,
          width: width,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
