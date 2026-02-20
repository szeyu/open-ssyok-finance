import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ssyok_finance/core/constants/firebase_constants.dart';
import 'package:ssyok_finance/features/onboarding/domain/user_profile.dart';

/// Repository for managing user profile data in Firestore
class ProfileRepository {
  final FirebaseFirestore _firestore;

  ProfileRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Watch user profile stream
  Stream<UserProfile?> watchProfile(String uid) {
    return _firestore
        .collection(FirebaseConstants.usersCollection)
        .doc(uid)
        .snapshots()
        .map((snapshot) {
      if (!snapshot.exists || snapshot.data() == null) {
        return null;
      }
      return UserProfile.fromJson({
        ...snapshot.data()!,
        'uid': uid, // Ensure uid is included
      });
    });
  }

  /// Get user profile once
  Future<UserProfile?> getProfile(String uid) async {
    final doc = await _firestore
        .collection(FirebaseConstants.usersCollection)
        .doc(uid)
        .get();

    if (!doc.exists || doc.data() == null) {
      return null;
    }

    return UserProfile.fromJson({
      ...doc.data()!,
      'uid': uid,
    });
  }

  /// Save or update user profile
  Future<void> saveProfile(UserProfile profile) async {
    final data = profile.toJson();
    data.remove('uid'); // Don't store uid in document data

    await _firestore
        .collection(FirebaseConstants.usersCollection)
        .doc(profile.uid)
        .set(data, SetOptions(merge: true));
  }

  /// Delete user profile
  Future<void> deleteProfile(String uid) async {
    await _firestore
        .collection(FirebaseConstants.usersCollection)
        .doc(uid)
        .delete();
  }
}
