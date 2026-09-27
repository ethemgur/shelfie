// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remote_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(firebaseAuth)
final firebaseAuthProvider = FirebaseAuthProvider._();

final class FirebaseAuthProvider
    extends $FunctionalProvider<FirebaseAuth, FirebaseAuth, FirebaseAuth>
    with $Provider<FirebaseAuth> {
  FirebaseAuthProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'firebaseAuthProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$firebaseAuthHash();

  @$internal
  @override
  $ProviderElement<FirebaseAuth> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  FirebaseAuth create(Ref ref) {
    return firebaseAuth(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FirebaseAuth value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FirebaseAuth>(value),
    );
  }
}

String _$firebaseAuthHash() => r'8c3e9d11b27110ca96130356b5ef4d5d34a5ffc2';

@ProviderFor(firestore)
final firestoreProvider = FirestoreProvider._();

final class FirestoreProvider
    extends
        $FunctionalProvider<
          FirebaseFirestore,
          FirebaseFirestore,
          FirebaseFirestore
        >
    with $Provider<FirebaseFirestore> {
  FirestoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'firestoreProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$firestoreHash();

  @$internal
  @override
  $ProviderElement<FirebaseFirestore> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FirebaseFirestore create(Ref ref) {
    return firestore(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FirebaseFirestore value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FirebaseFirestore>(value),
    );
  }
}

String _$firestoreHash() => r'864285def6284159b44f9598dcde96347e0c1dce';

@ProviderFor(storage)
final storageProvider = StorageProvider._();

final class StorageProvider
    extends
        $FunctionalProvider<FirebaseStorage, FirebaseStorage, FirebaseStorage>
    with $Provider<FirebaseStorage> {
  StorageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'storageProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$storageHash();

  @$internal
  @override
  $ProviderElement<FirebaseStorage> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  FirebaseStorage create(Ref ref) {
    return storage(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FirebaseStorage value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FirebaseStorage>(value),
    );
  }
}

String _$storageHash() => r'ee84a5c797d6826309f5194ebc48425f387d56b6';

@ProviderFor(functions)
final functionsProvider = FunctionsProvider._();

final class FunctionsProvider
    extends
        $FunctionalProvider<
          FirebaseFunctions,
          FirebaseFunctions,
          FirebaseFunctions
        >
    with $Provider<FirebaseFunctions> {
  FunctionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'functionsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$functionsHash();

  @$internal
  @override
  $ProviderElement<FirebaseFunctions> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FirebaseFunctions create(Ref ref) {
    return functions(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FirebaseFunctions value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FirebaseFunctions>(value),
    );
  }
}

String _$functionsHash() => r'5645757b6e3e0048a47edd8a5f571007d005c0fc';

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
