// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'circuit_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(circuitRepository)
final circuitRepositoryProvider = CircuitRepositoryProvider._();

final class CircuitRepositoryProvider
    extends
        $FunctionalProvider<
          CircuitRepository,
          CircuitRepository,
          CircuitRepository
        >
    with $Provider<CircuitRepository> {
  CircuitRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'circuitRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$circuitRepositoryHash();

  @$internal
  @override
  $ProviderElement<CircuitRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CircuitRepository create(Ref ref) {
    return circuitRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CircuitRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CircuitRepository>(value),
    );
  }
}

String _$circuitRepositoryHash() => r'7c8355a503e39bcf8a0d6c4bf1f4c11a176581dc';
