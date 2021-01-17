import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

void doAndReportOnCrash(String functionName, VoidCallback function) {
  try {
    function();
  } catch (e, s) {
    _onCatch(e, s, functionName);

  }
}

Future<void> awaitAndReportOnCrash(String functionName, Future future()) async {
  try {
    await future();
  } catch (e, s) {
    _onCatch(e, s, functionName);
  }
}

void _onCatch(e, StackTrace s, String functionName) {
  FirebaseCrashlytics.instance
      .recordError(e, s, reason: 'when calling $functionName');
}
