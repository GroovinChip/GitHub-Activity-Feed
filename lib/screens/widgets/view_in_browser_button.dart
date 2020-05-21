import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

class ViewInBrowserButton extends StatelessWidget {
  const ViewInBrowserButton({
    Key key,
    @required this.url,
  }) : super(key: key);

  final String url;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(MdiIcons.earth),
      onPressed: () => url_launcher.launch(url),
    );
  }
}
