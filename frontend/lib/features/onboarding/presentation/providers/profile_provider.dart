import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ssyok_finance/core/services/local_storage_service.dart';
import 'package:ssyok_finance/features/auth/presentation/providers/auth_provider.dart';
import 'package:ssyok_finance/features/onboarding/data/profile_repository.dart';
import 'package:ssyok_finance/features/onboarding/domain/user_profile.dart';

/// Provider for ProfileRepository instance
final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository();
});

/// Provider for current user's profile stream
final userProfileProvider = StreamProvider<UserProfile?>((ref) {
  final authState = ref.watch(authStateProvider);
  final user = authState.value;

  if (user == null) {
    return Stream.value(null);
  }

  final profileRepository = ref.watch(profileRepositoryProvider);
  return profileRepository.watchProfile(user.uid);
});

/// Whether onboarding is complete — reads from SharedPreferences (fast, local).
/// Falls back to false while local storage is initialising.
final hasCompletedOnboardingProvider = Provider<bool>((ref) {
  final localStorageAsync = ref.watch(localStorageServiceProvider);
  return localStorageAsync.when(
    data: (localStorage) => localStorage.getOnboardingComplete(),
    loading: () => false,
    error: (_, _) => false,
  );
});
