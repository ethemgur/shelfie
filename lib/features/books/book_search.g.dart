// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_search.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(bookSearch)
final bookSearchProvider = BookSearchProvider._();

final class BookSearchProvider
    extends $FunctionalProvider<BookSearch, BookSearch, BookSearch>
    with $Provider<BookSearch> {
  BookSearchProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bookSearchProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bookSearchHash();

  @$internal
  @override
  $ProviderElement<BookSearch> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  BookSearch create(Ref ref) {
    return bookSearch(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BookSearch value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BookSearch>(value),
    );
  }
}

String _$bookSearchHash() => r'b4d7ae5868b629a2949255ca1bb6cd9a802d6314';

/// Results for one query. Debounced by the search screen.

@ProviderFor(bookSearchResults)
final bookSearchResultsProvider = BookSearchResultsFamily._();

/// Results for one query. Debounced by the search screen.

final class BookSearchResultsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<BookCandidate>>,
          List<BookCandidate>,
          FutureOr<List<BookCandidate>>
        >
    with
        $FutureModifier<List<BookCandidate>>,
        $FutureProvider<List<BookCandidate>> {
  /// Results for one query. Debounced by the search screen.
  BookSearchResultsProvider._({
    required BookSearchResultsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'bookSearchResultsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$bookSearchResultsHash();

  @override
  String toString() {
    return r'bookSearchResultsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<BookCandidate>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<BookCandidate>> create(Ref ref) {
    final argument = this.argument as String;
    return bookSearchResults(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is BookSearchResultsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$bookSearchResultsHash() => r'e0657028e61d265d3c6ba699d23cd0d0065faaf9';

/// Results for one query. Debounced by the search screen.

final class BookSearchResultsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<BookCandidate>>, String> {
  BookSearchResultsFamily._()
    : super(
        retry: null,
        name: r'bookSearchResultsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Results for one query. Debounced by the search screen.

  BookSearchResultsProvider call(String query) =>
      BookSearchResultsProvider._(argument: query, from: this);

  @override
  String toString() => r'bookSearchResultsProvider';
}
