import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ssyok_finance/features/auth/data/auth_repository.dart';

/// Provider for AuthRepository instance
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

/// Provider for authentication state stream
final authStateProvider = StreamProvider<User?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges();
});

/// Provider for current user
final currentUserProvider = Provider<User?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.currentUser;
});

/// Provider for sign-in action
final signInProvider = Provider<Future<UserCredential> Function()>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return () => authRepository.signInWithGoogle();
});

/// Provider for sign-out action
final signOutProvider = Provider<Future<void> Function()>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return () => authRepository.signOut();
});
