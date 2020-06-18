import 'package:flutter/material.dart';
import 'package:github_activity_feed/data/trending_repositories.dart';
import 'package:github_activity_feed/data/trending_users.dart';
import 'package:github_activity_feed/services/discovery_service.dart';
import 'package:github_activity_feed/utils/extensions.dart';
import 'package:github_activity_feed/widgets/discovery/trending_repository_card.dart';
import 'package:github_activity_feed/widgets/user_widgets/user_avatar.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

//todo: repos/developers connected to viewer's top used language
//todo: top repos/developers followed/starred by users the viewer follows
class Discovery extends StatefulWidget {
  @override
  _DiscoveryState createState() => _DiscoveryState();
}

class _DiscoveryState extends State<Discovery> {
  DiscoveryService discoveryService;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    discoveryService = Provider.of<DiscoveryService>(context);
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        /// Trending repos
        SliverToBoxAdapter(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Text(
                  'Trending Repositories',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              SizedBox(height: 8),
            ],
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            height: 200,
            child: ListView.builder(
              padding: const EdgeInsets.only(left: 8, right: 8),
              scrollDirection: Axis.horizontal,
              itemCount: discoveryService.trendingRepositories.length,
              itemBuilder: (BuildContext context, int index) {
                TrendingRepository repo =
                    discoveryService.trendingRepositories[index];
                return TrendingRepositoryCard(repo: repo);
              },
            ),
          ),
        ),

        /// Trending Users
        SliverToBoxAdapter(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Text(
                  'Trending Users',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              SizedBox(height: 8),
            ],
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            height: 225,
            child: ListView.builder(
              padding: const EdgeInsets.only(left: 8, right: 8),
              scrollDirection: Axis.horizontal,
              itemCount: discoveryService.trendingUsers.length,
              itemBuilder: (BuildContext context, int index) {
                TrendingUser trendingUser =
                    discoveryService.trendingUsers[index];
                return Container(
                  //height: 275,
                  width: 275,
                  child: Card(
                    color: context.isDarkTheme
                        ? Colors.grey.shade900
                        : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: InkWell(
                      onTap: () => launch(trendingUser.url),
                      customBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  UserAvatar(
                                    avatarUrl: trendingUser.avatar,
                                    height: 44,
                                    width: 44,
                                  ),
                                  SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            trendingUser.name ??
                                                trendingUser.username,
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: context.isDarkTheme
                                                  ? Colors.grey
                                                  : Colors.grey.shade800,
                                            ),
                                          ),
                                        ),
                                        FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            '@${trendingUser.username}',
                                            style: TextStyle(
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(4, 8, 8, 8),
                              child: Row(
                                children: [
                                  Icon(
                                    MdiIcons.fire,
                                    color: Colors.red,
                                  ),
                                  SizedBox(width: 8),
                                  Text('Popular repo'.toUpperCase()),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 4.0, right: 8.0),
                              child: Row(
                                children: [
                                  Icon(MdiIcons.sourceRepository),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(trendingUser.repo.name),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 8.0, right: 8.0, top: 8.0),
                              child: Text(
                                trendingUser.repo.description,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
