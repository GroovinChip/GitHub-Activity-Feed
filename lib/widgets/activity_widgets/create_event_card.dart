import 'package:flutter/material.dart';
import 'package:github/github.dart';
import 'package:github_activity_feed/app/provided.dart';
import 'package:github_activity_feed/widgets/activity_widgets/count_item.dart';
import 'package:github_activity_feed/widgets/activity_widgets/event_card.dart';
import 'package:github_activity_feed/widgets/activity_widgets/language_label.dart';
import 'package:github_activity_feed/widgets/user_widgets/user_avatar.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;

//todo: some graphQL trickery to get the repo, or language info, etc?
class CreateEventCard extends StatefulWidget {
  const CreateEventCard({
    Key key,
    this.createEvent,
  }) : super(key: key);

  final Event createEvent;

  @override
  _CreateEventCardState createState() => _CreateEventCardState();
}

class _CreateEventCardState extends State<CreateEventCard> with ProvidedState {
  RepositorySlug repositorySlug;
  Repository repository;
  Future<Repository> _getRepository;

  @override
  void initState() {
    super.initState();
    _getRepository = getRepository();
  }

  Future<Repository> getRepository() async {
    try {
      repositorySlug = RepositorySlug.full(widget.createEvent.repo.name);
    } catch (e) {
      print('$e');
    }

    if (repositorySlug == null) {
      return null;
    }

    repository = await github.repositories.getRepository(repositorySlug);
    return repository;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Repository>(
      future: _getRepository,
      initialData: repository,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            !snapshot.hasData) {
          return Container();
        }

        UserInformation owner = snapshot.data?.owner;
        return EventCard(
          eventHeader: ListTile(
            /// Owner avatar
            leading: UserAvatar(
              avatarUrl: owner?.avatarUrl,
              userUrl: owner?.htmlUrl,
              height: 44,
              width: 44,
            ),

            /// Actor with action
            title: Text(
              '${widget.createEvent.actor.login} created a repository',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),

            /// Fuzzy timestamp
            subtitle: Text(
                timeago.format(widget.createEvent.createdAt, locale: 'en')),
          ),
          eventPreviewWebUrl: snapshot.data?.htmlUrl,
          eventPreview: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.createEvent.repo.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Text(snapshot.data?.description ?? 'No description'),
              SizedBox(height: 8),
              Row(
                children: [
                  CountItem(
                    iconData: Icons.remove_red_eye_outlined,
                    countItem: snapshot.data?.watchersCount,
                  ),
                  SizedBox(width: 16),
                  CountItem(
                    iconData: Icons.star_outline,
                    countItem: snapshot.data?.stargazersCount,
                  ),
                  SizedBox(width: 16),
                  CountItem(
                    iconData: MdiIcons.sourceFork,
                    countItem: snapshot.data?.forksCount,
                  ),
                  SizedBox(width: 16),
                  LanguageLabel(
                    language: snapshot.data?.language,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
