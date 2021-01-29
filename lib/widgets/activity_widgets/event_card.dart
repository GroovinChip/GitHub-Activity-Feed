import 'package:flutter/material.dart';
import 'package:github_activity_feed/theme/github_colors.dart';
import 'package:github_activity_feed/utils/extensions.dart';
import 'package:github_activity_feed/widgets/octicons/oct_icons16_icons.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

typedef LaunchRepoInBrowserCallback = Future<void> Function();

class EventCard extends StatelessWidget {
  const EventCard({
    Key key,
    @required this.eventHeader,
    @required this.eventPreview,
    @required this.eventPreviewWebUrl,
    this.showForkButton = false,
    this.forkUrl,
  }) : super(key: key);

  final Widget eventHeader;
  final Widget eventPreview;
  final String eventPreviewWebUrl;
  final bool showForkButton;
  final String forkUrl;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Material(
        elevation: 2,
        color: context.isDarkTheme ? GhColors.grey.shade800 : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            eventHeader,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Material(
                      color: context.isDarkTheme
                          ? GhColors.grey.shade900
                          : GhColors.grey.shadeZero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: InkWell(
                        customBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        onTap: () async {
                          if (await url_launcher
                              .canLaunch(eventPreviewWebUrl)) {
                            url_launcher.launch(eventPreviewWebUrl);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: eventPreview,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (showForkButton) ...[
              Row(
                children: [
                  SizedBox(width: 16),
                  TextButton.icon(
                    icon: Icon(
                      OctIcons16.link_external_16,
                      size: 16,
                      color: GhColors.blue.shade400,
                    ),
                    label: Text(
                      'View fork',
                      style: TextStyle(
                        color: GhColors.blue.shade400,
                      ),
                    ),
                    onPressed: () async {
                      if (await url_launcher.canLaunch(forkUrl)) {
                        url_launcher.launch(forkUrl);
                      }
                    },
                  ),
                ],
              )
            ] else
              SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
