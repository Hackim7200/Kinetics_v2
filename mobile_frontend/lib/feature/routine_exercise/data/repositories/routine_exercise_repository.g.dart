// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routine_exercise_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(routineExerciseRepository)
final routineExerciseRepositoryProvider = RoutineExerciseRepositoryProvider._();

final class RoutineExerciseRepositoryProvider
    extends
        $FunctionalProvider<
          RoutineExerciseRepository,
          RoutineExerciseRepository,
          RoutineExerciseRepository
        >
    with $Provider<RoutineExerciseRepository> {
  RoutineExerciseRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'routineExerciseRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$routineExerciseRepositoryHash();

  @$internal
  @override
  $ProviderElement<RoutineExerciseRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RoutineExerciseRepository create(Ref ref) {
    return routineExerciseRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RoutineExerciseRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RoutineExerciseRepository>(value),
    );
  }
}

String _$routineExerciseRepositoryHash() =>
    r'd92946f9c47c65a490e313594c2de45b82ece040';
