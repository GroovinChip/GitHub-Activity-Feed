import 'package:flutter/material.dart';
import 'package:github_activity_feed/services/discovery_service.dart';

class Discovery extends StatefulWidget {
  @override
  _DiscoveryState createState() => _DiscoveryState();
}

class _DiscoveryState extends State<Discovery> {
  DiscoveryService discoveryService = DiscoveryService();
  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
      future: discoveryService.getTrendingRepositories(),
      builder: (context, snapshot) {
        //print(snapshot.data);
        return CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate([
                Center(
                  child: Text('Discover'),
                ),
              ]),
            ),
          ],
        );
      }
    );
  }
}
