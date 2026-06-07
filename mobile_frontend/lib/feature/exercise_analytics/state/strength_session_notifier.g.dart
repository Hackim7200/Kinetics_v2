// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'strength_session_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Owns live strength session state and coordinates load / persist / add / finish.

@ProviderFor(StrengthSessionNotifier)
final strengthSessionProvider = StrengthSessionNotifierFamily._();

/// Owns live strength session state and coordinates load / persist / add / finish.
final class StrengthSessionNotifierProvider
    extends $NotifierProvider<StrengthSessionNotifier, StrengthSessionState> {
  /// Owns live strength session state and coordinates load / persist / add / finish.
  StrengthSessionNotifierProvider._({
    required StrengthSessionNotifierFamily super.from,
    required (String?, int) super.argument,
  }) : super(
         retry: null,
         name: r'strengthSessionProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$strengthSessionNotifierHash();

  @override
  String toString() {
    return r'strengthSessionProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  StrengthSessionNotifier create() => StrengthSessionNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StrengthSessionState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StrengthSessionState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is StrengthSessionNotifierProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$strengthSessionNotifierHash() =>
    r'2f750eeed330714e3f0931dfc36e9768ddd31512';

/// Owns live strength session state and coordinates load / persist / add / finish.

final class StrengthSessionNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          StrengthSessionNotifier,
          StrengthSessionState,
          StrengthSessionState,
          StrengthSessionState,
          (String?, int)
        > {
  StrengthSessionNotifierFamily._()
    : super(
        retry: null,
        name: r'strengthSessionProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Owns live strength session state and coordinates load / persist / add / finish.

  StrengthSessionNotifierProvider call(
    String? routineExerciseId,
    int maxSets,
  ) => StrengthSessionNotifierProvider._(
    argument: (routineExerciseId, maxSets),
    from: this,
  );

  @override
  String toString() => r'strengthSessionProvider';
}

/// Owns live strength session state and coordinates load / persist / add / finish.

abstract class _$StrengthSessionNotifier
    extends $Notifier<StrengthSessionState> {
  late final _$args = ref.$arg as (String?, int);
  String? get routineExerciseId => _$args.$1;
  int get maxSets => _$args.$2;

  StrengthSessionState build(String? routineExerciseId, int maxSets);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<StrengthSessionState, StrengthSessionState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<StrengthSessionState, StrengthSessionState>,
              StrengthSessionState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args.$1, _$args.$2));
  }
}
