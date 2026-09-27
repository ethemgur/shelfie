// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalogue_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(catalogueRepository)
final catalogueRepositoryProvider = CatalogueRepositoryProvider._();

final class CatalogueRepositoryProvider
    extends
        $FunctionalProvider<
          CatalogueRepository,
          CatalogueRepository,
          CatalogueRepository
        >
    with $Provider<CatalogueRepository> {
  CatalogueRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'catalogueRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$catalogueRepositoryHash();

  @$internal
  @override
  $ProviderElement<CatalogueRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CatalogueRepository create(Ref ref) {
    return catalogueRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CatalogueRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CatalogueRepository>(value),
    );
  }
}

String _$catalogueRepositoryHash() =>
    r'5891db808390a5b440e6c883fd3cfece3648cf63';
