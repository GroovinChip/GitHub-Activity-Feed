import 'package:flutter/material.dart';
import 'package:github_activity_feed/data/activity_events/activity_pull_request.dart';
import 'package:github_activity_feed/theme/github_colors.dart';
import 'package:github_activity_feed/utils/extensions.dart';
import 'package:github_activity_feed/widgets/activity_widgets/event_card.dart';
import 'package:github_activity_feed/widgets/octicons/oct_icons16_icons.dart';
import 'package:github_activity_feed/widgets/user_widgets/user_avatar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeago/timeago.dart' as timeago;

class PrEventCard extends StatelessWidget {
  const PrEventCard({
    this.pr,
  });

  final ActivityPullRequest pr;

  @override
  Widget build(BuildContext context) {
    return EventCard(
      eventHeader: ListTile(
        leading: UserAvatar(
          avatarUrl: pr.actor.avatarUrl,
          userUrl: pr.actor.htmlUrl,
          height: 44,
          width: 44,
        ),
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: pr.actor.login,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: ' opened pull request ',
              ),
              TextSpan(
                text: '#${pr.pullRequest.number}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: ' at ',
              ),
              TextSpan(
                text: pr.event.repo.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
            style: TextStyle(
              color: context.theme.textTheme.bodyText1.color,
              fontSize: 16,
            ),
          ),
        ),
        subtitle: Text(timeago.format(pr.createdAt, locale: 'en')),
      ),
      eventPreview: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UserAvatar(
                avatarUrl: pr.event.actor.avatarUrl,
                height: 25,
                width: 25,
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  pr.pullRequest.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (pr.pullRequest.merged) ...[
                Icon(
                  OctIcons16.git_merge_16,
                  size: 16,
                  color: GhColors.purple,
                ),
              ],
            ],
          ),
          SizedBox(height: 8),
          Wrap(
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: pr.actor.login,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(text: ' wants to merge '),
                    TextSpan(
                      text: pr.pullRequest.head.label,
                      style: GoogleFonts.firaCode().copyWith(
                        color: context.isDarkTheme
                            ? GhColors.blue.shade300
                            : GhColors.blue,
                      ),
                    ),
                    TextSpan(text: ' into '),
                    TextSpan(
                      text: pr.pullRequest.base.label,
                      style: GoogleFonts.firaCode().copyWith(
                        color: context.isDarkTheme
                            ? GhColors.blue.shade300
                            : GhColors.blue,
                      ),
                    ),
                  ],
                  style: TextStyle(
                    color: context.onSurface,
                  ),
                ),
              ),
            ],
          ),

          //todo: pr counts (not included in payload??)
        ],
      ),
      eventPreviewWebUrl: pr.pullRequest.htmlUrl,
    );
  }
}
