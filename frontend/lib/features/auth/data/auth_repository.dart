import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Repository handling authentication operations
class AuthRepository {
  FirebaseAuth? _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  AuthRepository({FirebaseAuth? firebaseAuth, GoogleSignIn? googleSignIn})
    : _googleSignIn = googleSignIn ?? GoogleSignIn() {
    try {
      _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;
    } catch (e) {
      // Firebase not initialized
      _firebaseAuth = null;
    }
  }

  /// Stream of authentication state changes
  Stream<User?> authStateChanges() {
    return _firebaseAuth?.authStateChanges() ?? Stream.value(null);
  }

  /// Get current user
  User? get currentUser => _firebaseAuth?.currentUser;

  /// Sign in with Google
  Future<UserCredential> signInWithGoogle() async {
    try {
      // Clear cached account so the account picker always appears
      await _googleSignIn.signOut();

      // Trigger the Google Sign-In flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // User cancelled the sign-in
        throw AuthException(
          'sign-in-cancelled',
          'Google sign-in was cancelled',
        );
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      if (_firebaseAuth != null) {
        return await _firebaseAuth!.signInWithCredential(credential);
      } else {
        throw AuthException(
          'firebase-not-initialized',
          'Firebase is not available.',
        );
      }
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.code, e.message ?? 'Authentication failed');
    } catch (e) {
      throw AuthException('unknown', 'An unexpected error occurred: $e');
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      await Future.wait([
        if (_firebaseAuth != null) _firebaseAuth!.signOut(),
        _googleSignIn.signOut(),
      ]);
    } catch (e) {
      throw AuthException('sign-out-failed', 'Failed to sign out: $e');
    }
  }
}

/// Custom exception for authentication errors
class AuthException implements Exception {
  final String code;
  final String message;

  AuthException(this.code, this.message);

  @override
  String toString() => 'AuthException($code): $message';
}
