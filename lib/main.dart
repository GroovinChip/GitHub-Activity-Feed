import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:github_activity_feed/app/app.dart';
import 'package:github_activity_feed/services/auth_service.dart';
import 'package:github_activity_feed/services/discovery_service.dart';
import 'package:github_activity_feed/services/github_service.dart';
import 'package:github_activity_feed/state/prefs_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final firebaseApp = await Firebase.initializeApp();
  if (firebaseApp != null) {
    if (kDebugMode) {
      // Enable automatic data collection by Crashlytics
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    } else {
      // Disable automatic data collection by Crashlytics
      await FirebaseCrashlytics.instance
          .setCrashlyticsCollectionEnabled(!kDebugMode);

      // Pass all uncaught errors to Crashlytics.
      Function originalOnError = FlutterError.onError;
      FlutterError.onError = (FlutterErrorDetails errorDetails) async {
        await FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
        // Forward to original handler.
        originalOnError(errorDetails);
      };
    }

    // Init services
    final authService = await AuthService.init();
    final githubService = await GitHubService.init(authService);
    final prefsBloc = await PrefsBloc.init();
    final discoveryService = await DiscoveryService.init();

    runApp(
      GitHubActivityFeedApp(
        authService: authService,
        githubService: githubService,
        prefsBloc: prefsBloc,
        discoveryService: discoveryService,
      ),
    );
  } else {
    throw Exception();
  }
}
