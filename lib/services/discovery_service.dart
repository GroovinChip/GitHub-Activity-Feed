import 'dart:convert';

import 'package:github_activity_feed/data/trending_repositories.dart';
import 'package:http/http.dart' as http;

class DiscoveryService {
  DiscoveryService._();

  static Future<DiscoveryService> init() async {
    final discoveryService = DiscoveryService._();
    await discoveryService._init();
    return discoveryService;
  }

  Future<void> _init() async {
    trendingRepositories = await getTrendingRepositories();
    print('Discovery Service: Got trending repos');
  }

  List<TrendingRepository> trendingRepositories;

  /// Get today's trending GitHub repositories
  Future<List<TrendingRepository>> getTrendingRepositories() async {
    final response = await http.get('https://ghapi.huchen.dev/repositories?&since=daily');
    final trending = jsonDecode(response.body);
    List<TrendingRepository> trendingRepositories = List<TrendingRepository>();
    for (Map tr in trending) {
      trendingRepositories.add(TrendingRepository.fromJson(tr));
    }
    return trendingRepositories;
  }
}
