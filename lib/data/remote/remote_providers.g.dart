// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remote_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Only read once `Supabase.initialize` has run (see `main.dart`); the app
/// shows a "not configured" screen otherwise.

@ProviderFor(supabase)
final supabaseProvider = SupabaseProvider._();

/// Only read once `Supabase.initialize` has run (see `main.dart`); the app
/// shows a "not configured" screen otherwise.

final class SupabaseProvider
    extends $FunctionalProvider<SupabaseClient, SupabaseClient, SupabaseClient>
    with $Provider<SupabaseClient> {
  /// Only read once `Supabase.initialize` has run (see `main.dart`); the app
  /// shows a "not configured" screen otherwise.
  SupabaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'supabaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$supabaseHash();

  @$internal
  @override
  $ProviderElement<SupabaseClient> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SupabaseClient create(Ref ref) {
    return supabase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SupabaseClient value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SupabaseClient>(value),
    );
  }
}

String _$supabaseHash() => r'7750c766113ae9b14a18705c73c53e2e92e2ddbd';

@ProviderFor(httpClient)
final httpClientProvider = HttpClientProvider._();

final class HttpClientProvider
    extends $FunctionalProvider<http.Client, http.Client, http.Client>
    with $Provider<http.Client> {
  HttpClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'httpClientProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$httpClientHash();

  @$internal
  @override
  $ProviderElement<http.Client> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  http.Client create(Ref ref) {
    return httpClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(http.Client value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<http.Client>(value),
    );
  }
}

String _$httpClientHash() => r'7ec49beae0f15115de79f9aa98dbd250130e26d8';

@ProviderFor(openLibraryApi)
final openLibraryApiProvider = OpenLibraryApiProvider._();

final class OpenLibraryApiProvider
    extends $FunctionalProvider<OpenLibraryApi, OpenLibraryApi, OpenLibraryApi>
    with $Provider<OpenLibraryApi> {
  OpenLibraryApiProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'openLibraryApiProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$openLibraryApiHash();

  @$internal
  @override
  $ProviderElement<OpenLibraryApi> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  OpenLibraryApi create(Ref ref) {
    return openLibraryApi(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OpenLibraryApi value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OpenLibraryApi>(value),
    );
  }
}

String _$openLibraryApiHash() => r'da70ac189a82e517ad269a35dec69cb53c2179a5';

@ProviderFor(googleBooksApi)
final googleBooksApiProvider = GoogleBooksApiProvider._();

final class GoogleBooksApiProvider
    extends $FunctionalProvider<GoogleBooksApi, GoogleBooksApi, GoogleBooksApi>
    with $Provider<GoogleBooksApi> {
  GoogleBooksApiProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'googleBooksApiProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$googleBooksApiHash();

  @$internal
  @override
  $ProviderElement<GoogleBooksApi> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GoogleBooksApi create(Ref ref) {
    return googleBooksApi(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GoogleBooksApi value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GoogleBooksApi>(value),
    );
  }
}

String _$googleBooksApiHash() => r'6cec17af2a7f6eaad20a8aa63f16dfb209cd3d4e';
