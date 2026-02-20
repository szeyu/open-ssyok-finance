import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ssyok_finance/core/constants/firebase_constants.dart';
import 'package:ssyok_finance/core/utils/firestore_utils.dart';
import 'package:ssyok_finance/features/plan/domain/goal.dart';

class GoalsRepository {
  final FirebaseFirestore _firestore;

  GoalsRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Stream<List<Goal>> watchAll(String userId) {
    return _firestore
        .collection(FirebaseConstants.usersCollection)
        .doc(userId)
        .collection(FirebaseConstants.goalsCollection)
        .orderBy('targetDate')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Goal.fromJson(normalizeFirestoreData({...doc.data(), 'id': doc.id})))
            .toList());
  }

  Future<void> add(Goal goal) async {
    final docRef = _firestore
        .collection(FirebaseConstants.usersCollection)
        .doc(goal.userId)
        .collection(FirebaseConstants.goalsCollection)
        .doc();

    final data = goal.toJson()..remove('id');
    data['createdAt'] = FieldValue.serverTimestamp();
    data['updatedAt'] = FieldValue.serverTimestamp();

    await docRef.set(data);
  }

  Future<void> update(Goal goal) async {
    final data = goal.toJson()..remove('id');
    data['updatedAt'] = FieldValue.serverTimestamp();

    await _firestore
        .collection(FirebaseConstants.usersCollection)
        .doc(goal.userId)
        .collection(FirebaseConstants.goalsCollection)
        .doc(goal.id)
        .update(data);
  }

  Future<void> delete(String userId, String id) async {
    await _firestore
        .collection(FirebaseConstants.usersCollection)
        .doc(userId)
        .collection(FirebaseConstants.goalsCollection)
        .doc(id)
        .delete();
  }
}
