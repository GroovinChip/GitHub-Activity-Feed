import 'package:flutter/material.dart';
import 'package:github_activity_feed/data/custom_repos.dart';
import 'package:groovin_widgets/groovin_widgets.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

/// Builds an [Icon] that corresponds to the most-used language in a
/// repository or gist*.
///
/// Builds a [Text] with the language name if the
/// language doesn't have corresponding IconData in [_languageIcons].
///
/// * gists are not currently supported in-app, but this widget will be compatible
/// with gists should they be added in the future.
class LanguageIcon extends StatefulWidget {
  const LanguageIcon({
    Key key,
    this.language,
  }) : super(key: key);

  final Language language;

  @override
  _LanguageIconState createState() => _LanguageIconState();
}

class _LanguageIconState extends State<LanguageIcon> {
  IconData languageIcon;

  @override
  void initState() {
    super.initState();
    _setLanguageIconData();
  }

  void _setLanguageIconData() {
    _languageIcons.forEach((lang, icon) {
      if (lang == widget.language.name) {
        setState(() => languageIcon = icon);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        languageIcon != null
            ? Icon(
                languageIcon,
                color: HexColor(widget.language.color),
              )
            : Text(
                widget.language.name,
                style: TextStyle(
                  color: HexColor(widget.language.color),
                ),
              ),
      ],
    );
  }
}

const _languageIcons = {
  'C': MdiIcons.languageC,
  'C++': MdiIcons.languageCpp,
  'C#': MdiIcons.languageCsharp,
  //todo: look up what label GH uses for css - has 3 or not?
  'CSS': MdiIcons.languageCss3,
  //todo: IconDate for Dart
  'Fortran': MdiIcons.languageFortran,
  'Go': MdiIcons.languageGo,
  'Haskell': MdiIcons.languageHaskell,
  //todo: look up what label GH uses for html - has 5 or not?
  'HTML': MdiIcons.languageHtml5,
  'Kotlin': MdiIcons.languageKotlin,
  'Java': MdiIcons.languageJava,
  'JavaScript': MdiIcons.languageJavascript,
  'Lua': MdiIcons.languageLua,
  'N/A': MdiIcons.languageMarkdown,
  'PHP': MdiIcons.languagePhp,
  'Python': MdiIcons.languagePython,
  'R': MdiIcons.languageR,
  'Ruby': MdiIcons.languageRuby,
  'Rust': MdiIcons.languageRust,
  'SCSS': MdiIcons.languageCss3, //todo: IconData for SASS
  'Shell': MdiIcons.powershell, //todo: IconData for Shell
  'Swift': MdiIcons.languageSwift,
  'TypeScript': MdiIcons.languageTypescript,
  'Xaml': MdiIcons.languageXaml,
  'XSLT': MdiIcons.xml //todo: IconData for XSLT
};
