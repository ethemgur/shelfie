// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_page_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(bookPage)
final bookPageProvider = BookPageFamily._();

final class BookPageProvider
    extends
        $FunctionalProvider<
          AsyncValue<BookPageData>,
          BookPageData,
          FutureOr<BookPageData>
        >
    with $FutureModifier<BookPageData>, $FutureProvider<BookPageData> {
  BookPageProvider._({
    required BookPageFamily super.from,
    required (String, String?) super.argument,
  }) : super(
         retry: null,
         name: r'bookPageProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$bookPageHash();

  @override
  String toString() {
    return r'bookPageProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<BookPageData> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<BookPageData> create(Ref ref) {
    final argument = this.argument as (String, String?);
    return bookPage(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is BookPageProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$bookPageHash() => r'22beeddfb280b2a7c98370d16873b2f8b71e8532';

final class BookPageFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<BookPageData>, (String, String?)> {
  BookPageFamily._()
    : super(
        retry: null,
        name: r'bookPageProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  BookPageProvider call(String workId, String? preferredEditionId) =>
      BookPageProvider._(argument: (workId, preferredEditionId), from: this);

  @override
  String toString() => r'bookPageProvider';
}
