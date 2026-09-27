import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../app/env.dart';
import '../../app/firebase_setup.dart';
import 'google_books_api.dart';
import 'open_library_api.dart';

part 'remote_providers.g.dart';

// Only read once `initFirebase` has succeeded (see `main.dart`); the app shows
// a "not configured" screen otherwise.

@Riverpod(keepAlive: true)
FirebaseAuth firebaseAuth(Ref ref) => FirebaseAuth.instance;

@Riverpod(keepAlive: true)
FirebaseFirestore firestore(Ref ref) => FirebaseFirestore.instance;

@Riverpod(keepAlive: true)
FirebaseStorage storage(Ref ref) => FirebaseStorage.instance;

@Riverpod(keepAlive: true)
FirebaseFunctions functions(Ref ref) =>
    FirebaseFunctions.instanceFor(region: functionsRegion);

@Riverpod(keepAlive: true)
http.Client httpClient(Ref ref) {
  final client = http.Client();
  ref.onDispose(client.close);
  return client;
}

@Riverpod(keepAlive: true)
OpenLibraryApi openLibraryApi(Ref ref) =>
    OpenLibraryApi(ref.watch(httpClientProvider));

@Riverpod(keepAlive: true)
GoogleBooksApi googleBooksApi(Ref ref) => GoogleBooksApi(
  ref.watch(httpClientProvider),
  apiKey: Env.googleBooksApiKey,
);
