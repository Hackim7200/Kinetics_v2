import 'package:mobile_frontend/feature/auth/data/sources/onboarding_local_source.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'onboarding_repository.g.dart';

/// Reads and writes whether the user has finished the one-time onboarding flow.
class OnboardingRepository {
  OnboardingRepository(this._local);

  final OnboardingLocalSource _local;

  Future<bool> isComplete() => _local.isOnboardingComplete();

  Future<void> markComplete() => _local.setOnboardingComplete();
}

@Riverpod(keepAlive: true)
OnboardingRepository onboardingRepository(Ref ref) {
  return OnboardingRepository(OnboardingLocalSource());
}
