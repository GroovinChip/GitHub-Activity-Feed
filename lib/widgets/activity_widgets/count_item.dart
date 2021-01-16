import 'package:flutter/material.dart';

class CountItem extends StatelessWidget {
  const CountItem({
    Key key,
    this.iconData,
    this.countItem,
  }) : super(key: key);

  final IconData iconData;
  final int countItem;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(iconData),
        SizedBox(width: 8),
        Text('${countItem ?? '-'}'),
      ],
    );
  }
}
