import 'package:flutter/material.dart';
import 'package:github_activity_feed/services/discovery_service.dart';
import 'package:provider/provider.dart';

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
        SliverToBoxAdapter(
          child: Container(),
        ),
      ],
    );
  }
}
