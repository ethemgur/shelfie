import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'env.dart';

/// Cloud Functions region (see `functions/src`).
const functionsRegion = 'europe-west1';

/// Initialises Firebase, or returns false if this build has no Firebase
/// config (the app then shows a "not configured" screen).
Future<bool> initFirebase() async {
  final options = await _options();
  if (options == null) return false;
  await Firebase.initializeApp(options: options);
  if (Env.useEmulators) {
    final host = Env.emulatorHost;
    await FirebaseAuth.instance.useAuthEmulator(host, 9099);
    FirebaseFirestore.instance.useFirestoreEmulator(host, 8080);
    await FirebaseStorage.instance.useStorageEmulator(host, 9199);
    FirebaseFunctions.instanceFor(region: functionsRegion)
        .useFunctionsEmulator(host, 5001);
  }
  return true;
}

Future<FirebaseOptions?> _options() async {
  if (Env.useEmulators) {
    // `demo-` projects run fully offline against the emulators.
    return const FirebaseOptions(
      apiKey: 'demo-key',
      appId: '1:0:web:0',
      messagingSenderId: '0',
      projectId: 'demo-shelfie',
      storageBucket: 'demo-shelfie.appspot.com',
    );
  }
  if (Env.firebaseApiKey.isNotEmpty) {
    final appId = kIsWeb
        ? Env.firebaseAppIdWeb
        : switch (defaultTargetPlatform) {
            TargetPlatform.iOS => Env.firebaseAppIdIos,
            _ => Env.firebaseAppIdAndroid,
          };
    return FirebaseOptions(
      apiKey: Env.firebaseApiKey,
      appId: appId,
      messagingSenderId: Env.firebaseMessagingSenderId,
      projectId: Env.firebaseProjectId,
      storageBucket: Env.firebaseStorageBucket,
      authDomain: Env.firebaseAuthDomain.isEmpty
          ? null
          : Env.firebaseAuthDomain,
    );
  }
  if (kIsWeb) return _hostingOptions();
  return null;
}

/// Firebase Hosting serves the project's web config at a reserved URL, so web
/// builds deployed there need no build-time config.
Future<FirebaseOptions?> _hostingOptions() async {
  try {
    final response = await http.get(Uri.base.resolve('/__/firebase/init.json'));
    if (response.statusCode != 200) return null;
    return optionsFromHostingConfig(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  } catch (_) {
    return null;
  }
}

/// Parses Firebase Hosting's `/__/firebase/init.json`. Null unless the
/// project has a registered Web app (which supplies `appId`).
@visibleForTesting
FirebaseOptions? optionsFromHostingConfig(Map<String, dynamic> json) {
  final apiKey = json['apiKey'] as String?;
  final appId = json['appId'] as String?;
  final projectId = json['projectId'] as String?;
  if (apiKey == null || appId == null || projectId == null) return null;
  return FirebaseOptions(
    apiKey: apiKey,
    appId: appId,
    messagingSenderId: json['messagingSenderId'] as String? ?? '',
    projectId: projectId,
    storageBucket: json['storageBucket'] as String?,
    authDomain: json['authDomain'] as String?,
    measurementId: json['measurementId'] as String?,
  );
}
