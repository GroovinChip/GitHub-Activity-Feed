import 'package:flutter/material.dart';
import 'package:github_activity_feed/utils/extensions.dart';

class CountItem extends StatelessWidget {
  const CountItem({
    Key key,
    @required this.iconData,
    @required this.countItem,
    this.itemColor,
  }) : super(key: key);

  final IconData iconData;
  final int countItem;
  final Color itemColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          iconData,
          size: 16,
          color: itemColor ?? context.onSurface,
        ),
        SizedBox(width: 6),
        Text('${countItem ?? '-'}'),
      ],
    );
  }
}
