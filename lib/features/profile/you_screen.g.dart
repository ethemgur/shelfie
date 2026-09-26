// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'you_screen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(followCounts)
final followCountsProvider = FollowCountsFamily._();

final class FollowCountsProvider
    extends
        $FunctionalProvider<
          AsyncValue<FollowCounts>,
          FollowCounts,
          FutureOr<FollowCounts>
        >
    with $FutureModifier<FollowCounts>, $FutureProvider<FollowCounts> {
  FollowCountsProvider._({
    required FollowCountsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'followCountsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$followCountsHash();

  @override
  String toString() {
    return r'followCountsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<FollowCounts> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<FollowCounts> create(Ref ref) {
    final argument = this.argument as String;
    return followCounts(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is FollowCountsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$followCountsHash() => r'c5fa3579c112f5156b209084e22314cea0db4388';

final class FollowCountsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<FollowCounts>, String> {
  FollowCountsFamily._()
    : super(
        retry: null,
        name: r'followCountsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  FollowCountsProvider call(String userId) =>
      FollowCountsProvider._(argument: userId, from: this);

  @override
  String toString() => r'followCountsProvider';
}
