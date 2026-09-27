// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_gate.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(sessionGate)
final sessionGateProvider = SessionGateProvider._();

final class SessionGateProvider
    extends $FunctionalProvider<SessionGate, SessionGate, SessionGate>
    with $Provider<SessionGate> {
  SessionGateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sessionGateProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sessionGateHash();

  @$internal
  @override
  $ProviderElement<SessionGate> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SessionGate create(Ref ref) {
    return sessionGate(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SessionGate value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SessionGate>(value),
    );
  }
}

String _$sessionGateHash() => r'f09575daddd1b93614d91e9932d3cbc859aeda78';

/// The signed-in user's profile, or null before onboarding.

@ProviderFor(currentProfile)
final currentProfileProvider = CurrentProfileProvider._();

/// The signed-in user's profile, or null before onboarding.

final class CurrentProfileProvider
    extends $FunctionalProvider<Profile?, Profile?, Profile?>
    with $Provider<Profile?> {
  /// The signed-in user's profile, or null before onboarding.
  CurrentProfileProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentProfileProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentProfileHash();

  @$internal
  @override
  $ProviderElement<Profile?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Profile? create(Ref ref) {
    return currentProfile(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Profile? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Profile?>(value),
    );
  }
}

String _$currentProfileHash() => r'9566b8aa9731935bb87d9c54d26e736e95561b1a';
