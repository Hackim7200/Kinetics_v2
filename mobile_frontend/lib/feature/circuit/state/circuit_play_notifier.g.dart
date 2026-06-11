// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'circuit_play_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Owns circuit play session: station load, countdown timer, and audio cues.

@ProviderFor(CircuitPlayNotifier)
final circuitPlayProvider = CircuitPlayNotifierFamily._();

/// Owns circuit play session: station load, countdown timer, and audio cues.
final class CircuitPlayNotifierProvider
    extends $NotifierProvider<CircuitPlayNotifier, CircuitPlayState> {
  /// Owns circuit play session: station load, countdown timer, and audio cues.
  CircuitPlayNotifierProvider._({
    required CircuitPlayNotifierFamily super.from,
    required Circuit super.argument,
  }) : super(
         retry: null,
         name: r'circuitPlayProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$circuitPlayNotifierHash();

  @override
  String toString() {
    return r'circuitPlayProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  CircuitPlayNotifier create() => CircuitPlayNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CircuitPlayState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CircuitPlayState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is CircuitPlayNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$circuitPlayNotifierHash() =>
    r'669a94a7f8aff49a4fc3749e9f76f6ad3d434798';

/// Owns circuit play session: station load, countdown timer, and audio cues.

final class CircuitPlayNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          CircuitPlayNotifier,
          CircuitPlayState,
          CircuitPlayState,
          CircuitPlayState,
          Circuit
        > {
  CircuitPlayNotifierFamily._()
    : super(
        retry: null,
        name: r'circuitPlayProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Owns circuit play session: station load, countdown timer, and audio cues.

  CircuitPlayNotifierProvider call(Circuit circuit) =>
      CircuitPlayNotifierProvider._(argument: circuit, from: this);

  @override
  String toString() => r'circuitPlayProvider';
}

/// Owns circuit play session: station load, countdown timer, and audio cues.

abstract class _$CircuitPlayNotifier extends $Notifier<CircuitPlayState> {
  late final _$args = ref.$arg as Circuit;
  Circuit get circuit => _$args;

  CircuitPlayState build(Circuit circuit);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<CircuitPlayState, CircuitPlayState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<CircuitPlayState, CircuitPlayState>,
              CircuitPlayState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
