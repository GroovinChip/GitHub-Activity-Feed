class DiscoveryService {
  DiscoveryService._();

  static Future<DiscoveryService> init() async {
    final discoveryService = DiscoveryService._();
    await discoveryService._init();
    return discoveryService;
  }

  Future<void> _init() async {
    //
  }

  // todo: custom graphQl discovery queries
}
