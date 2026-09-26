import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../app/env.dart';
import 'google_books_api.dart';
import 'open_library_api.dart';

part 'remote_providers.g.dart';

/// Only read once `Supabase.initialize` has run (see `main.dart`); the app
/// shows a "not configured" screen otherwise.
@Riverpod(keepAlive: true)
SupabaseClient supabase(Ref ref) => Supabase.instance.client;

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
