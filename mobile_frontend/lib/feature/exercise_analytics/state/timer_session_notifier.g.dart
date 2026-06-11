// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timer_session_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Owns live timer session state and coordinates load / log-set / finish.

@ProviderFor(TimerSessionNotifier)
final timerSessionProvider = TimerSessionNotifierFamily._();

/// Owns live timer session state and coordinates load / log-set / finish.
final class TimerSessionNotifierProvider
    extends $NotifierProvider<TimerSessionNotifier, TimerSessionState> {
  /// Owns live timer session state and coordinates load / log-set / finish.
  TimerSessionNotifierProvider._({
    required TimerSessionNotifierFamily super.from,
    required (String?, int) super.argument,
  }) : super(
         retry: null,
         name: r'timerSessionProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$timerSessionNotifierHash();

  @override
  String toString() {
    return r'timerSessionProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  TimerSessionNotifier create() => TimerSessionNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TimerSessionState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TimerSessionState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is TimerSessionNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$timerSessionNotifierHash() =>
    r'8465cdcd4e15800e4d4656964d7aa7db217a189c';

/// Owns live timer session state and coordinates load / log-set / finish.

final class TimerSessionNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          TimerSessionNotifier,
          TimerSessionState,
          TimerSessionState,
          TimerSessionState,
          (String?, int)
        > {
  TimerSessionNotifierFamily._()
    : super(
        retry: null,
        name: r'timerSessionProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Owns live timer session state and coordinates load / log-set / finish.

  TimerSessionNotifierProvider call(String? routineExerciseId, int maxSets) =>
      TimerSessionNotifierProvider._(
        argument: (routineExerciseId, maxSets),
        from: this,
      );

  @override
  String toString() => r'timerSessionProvider';
}

/// Owns live timer session state and coordinates load / log-set / finish.

abstract class _$TimerSessionNotifier extends $Notifier<TimerSessionState> {
  late final _$args = ref.$arg as (String?, int);
  String? get routineExerciseId => _$args.$1;
  int get maxSets => _$args.$2;

  TimerSessionState build(String? routineExerciseId, int maxSets);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<TimerSessionState, TimerSessionState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<TimerSessionState, TimerSessionState>,
              TimerSessionState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args.$1, _$args.$2));
  }
}
