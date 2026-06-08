// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'circuit_exercise_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(circuitExerciseRepository)
final circuitExerciseRepositoryProvider = CircuitExerciseRepositoryProvider._();

final class CircuitExerciseRepositoryProvider
    extends
        $FunctionalProvider<
          CircuitExerciseRepository,
          CircuitExerciseRepository,
          CircuitExerciseRepository
        >
    with $Provider<CircuitExerciseRepository> {
  CircuitExerciseRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'circuitExerciseRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$circuitExerciseRepositoryHash();

  @$internal
  @override
  $ProviderElement<CircuitExerciseRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CircuitExerciseRepository create(Ref ref) {
    return circuitExerciseRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CircuitExerciseRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CircuitExerciseRepository>(value),
    );
  }
}

String _$circuitExerciseRepositoryHash() =>
    r'4fb829de3af6968bcfed01adc978a0c4e4a4ecfb';
