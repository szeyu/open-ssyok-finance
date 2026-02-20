// Re-export providers needed by settings screens
export 'package:ssyok_finance/features/onboarding/presentation/providers/profile_provider.dart'
    show userProfileProvider, profileRepositoryProvider;
export 'package:ssyok_finance/features/onboarding/data/profile_repository.dart'
    show ProfileRepository;

// Alias for EditProfileScreen usage
import 'package:ssyok_finance/features/onboarding/data/profile_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userProfileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository();
});
