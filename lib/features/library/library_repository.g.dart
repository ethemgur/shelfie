// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(libraryRepository)
final libraryRepositoryProvider = LibraryRepositoryProvider._();

final class LibraryRepositoryProvider
    extends
        $FunctionalProvider<
          LibraryRepository,
          LibraryRepository,
          LibraryRepository
        >
    with $Provider<LibraryRepository> {
  LibraryRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'libraryRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$libraryRepositoryHash();

  @$internal
  @override
  $ProviderElement<LibraryRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  LibraryRepository create(Ref ref) {
    return libraryRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LibraryRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LibraryRepository>(value),
    );
  }
}

String _$libraryRepositoryHash() => r'fd47cf9e3f6d05bf15219c459d278f3935d48076';

@ProviderFor(myBooks)
final myBooksProvider = MyBooksProvider._();

final class MyBooksProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ShelvedBook>>,
          List<ShelvedBook>,
          FutureOr<List<ShelvedBook>>
        >
    with
        $FutureModifier<List<ShelvedBook>>,
        $FutureProvider<List<ShelvedBook>> {
  MyBooksProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'myBooksProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$myBooksHash();

  @$internal
  @override
  $FutureProviderElement<List<ShelvedBook>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ShelvedBook>> create(Ref ref) {
    return myBooks(ref);
  }
}

String _$myBooksHash() => r'940beb965a16c26dc500255f762775aed0dd4dbf';
