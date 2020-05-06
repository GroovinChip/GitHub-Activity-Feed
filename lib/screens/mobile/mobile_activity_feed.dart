import 'package:flutter/material.dart';
import 'package:github_activity_feed/app/provided.dart';
import 'package:github_activity_feed/screens/mobile/mobile_profile.dart';
import 'package:github_activity_feed/screens/widgets/following_feed.dart';

class MobileActivityFeed extends StatefulWidget {
  @override
  _MobileActivityFeedState createState() => _MobileActivityFeedState();
}

class _MobileActivityFeedState extends State<MobileActivityFeed> with ProvidedState {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkResponse(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                user.avatarUrl,
              ),
            ),
          ),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => MobileProfile()),
          ),
        ),
        title: Text(
          'Activity Feed',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: FollowingFeed(),
    );
  }
}
