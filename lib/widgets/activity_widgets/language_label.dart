import 'package:flutter/material.dart';
import 'package:github_activity_feed/data/custom_repos.dart';
import 'package:groovin_widgets/groovin_widgets.dart';

class LanguageLabel extends StatelessWidget {
  const LanguageLabel({
    Key key,
    this.language,
  }) : super(key: key);

  final Language language;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.language_outlined,
          color: HexColor(language.color),
        ),
        SizedBox(width: 8),
        Text(
          language.name,
          style: TextStyle(
            color: HexColor(language.color),
          ),
        ),
      ],
    );
  }
}
