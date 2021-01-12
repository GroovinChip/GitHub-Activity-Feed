import 'package:flutter/material.dart';

class LanguageLabel extends StatelessWidget {
  const LanguageLabel({
    Key key,
    this.language,
  }) : super(key: key);

  final String language;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.language_outlined),
        SizedBox(width: 8),
        Text(language ?? '-'),
      ],
    );
  }
}
