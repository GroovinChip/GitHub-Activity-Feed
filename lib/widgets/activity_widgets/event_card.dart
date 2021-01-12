import 'package:flutter/material.dart';
import 'package:github_activity_feed/utils/extensions.dart';

typedef LaunchRepoInBrowserCallback = Future<void> Function();

class EventCard extends StatelessWidget {
  const EventCard({
    Key key,
    @required this.launchInBrowser,
    @required this.eventHeader,
    @required this.eventPreview,
  }) : super(key: key);

  final VoidCallback launchInBrowser;
  final Widget eventHeader;
  final Widget eventPreview;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Material(
        elevation: 2,
        color: context.isDarkTheme ? Colors.grey[900] : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: InkWell(
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          onTap: () => launchInBrowser,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              eventHeader,
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                          color: context.isDarkTheme ? context.colorScheme.background : Colors.white, // update for light theme
                        ),
                        child: eventPreview,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
