import 'package:flutter/material.dart';
import 'package:github_activity_feed/data/activity_events/activity_member.dart';
import 'package:github_activity_feed/utils/extensions.dart';
import 'package:github_activity_feed/widgets/activity_widgets/event_card.dart';
import 'package:github_activity_feed/widgets/activity_widgets/repo_preview.dart';
import 'package:github_activity_feed/widgets/user_widgets/user_avatar.dart';
import 'package:groovin_widgets/groovin_widgets.dart';
import 'package:timeago/timeago.dart' as timeago;

class MemberEventCard extends StatelessWidget {
  const MemberEventCard({
    Key key,
    this.memberEvent,
  }) : super(key: key);

  final ActivityMember memberEvent;

  @override
  Widget build(BuildContext context) {
    printFormattedJson(memberEvent.event);
    return EventCard(
      eventHeader: ListTile(
        leading: UserAvatar(
          avatarUrl: memberEvent.actor.avatarUrl,
          userUrl: memberEvent.actor.htmlUrl,
          height: 44,
          width: 44,
        ),
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: memberEvent.actor.login,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: ' ${memberEvent.action} ',
              ),
              TextSpan(
                text: memberEvent.memberLogin,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: ' as a collaborator',
              ),
            ],
            style: TextStyle(
              color: context.theme.textTheme.bodyText1.color,
              fontSize: 16,
            ),
          ),
        ),
        subtitle: Text(timeago.format(memberEvent.createdAt, locale: 'en')),
      ),
      eventPreview: RepoPreview(
        avatarUrl: memberEvent.repo.owner.avatarUrl,
        repoName: memberEvent.repo.name,
        repoDescription: memberEvent.repo.description,
        watcherCount: memberEvent.repo.watcherCount,
        stargazerCount: memberEvent.repo.stargazerCount,
        forkCount: memberEvent.repo.forkCount,
        primaryLanguage: memberEvent.repo.languages.first,
      ),
      eventPreviewWebUrl: memberEvent.repo.url,
    );
  }
}
