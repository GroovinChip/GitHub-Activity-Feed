import 'package:flutter/material.dart';
import 'package:github_activity_feed/data/trending_repositories.dart';
import 'package:github_activity_feed/services/discovery_service.dart';
import 'package:github_activity_feed/widgets/discovery/trending_repository_card.dart';
import 'package:provider/provider.dart';

//todo: trending developers?
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
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Text(
                  'Trending Repositories',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              SizedBox(height: 16),
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
                TrendingRepository repo = discoveryService.trendingRepositories[index];
                return TrendingRepositoryCard(repo: repo);
              },
            ),
          ),
        ),
      ],
    );
  }
}
