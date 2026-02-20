import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ssyok_finance/core/constants/firebase_constants.dart';
import 'package:ssyok_finance/core/utils/firestore_utils.dart';
import 'package:ssyok_finance/features/plan/domain/debt.dart';

class DebtsRepository {
  final FirebaseFirestore _firestore;

  DebtsRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Stream<List<Debt>> watchAll(String userId) {
    return _firestore
        .collection(FirebaseConstants.usersCollection)
        .doc(userId)
        .collection(FirebaseConstants.debtsCollection)
        .orderBy('interestRate', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Debt.fromJson(normalizeFirestoreData({...doc.data(), 'id': doc.id})))
            .toList());
  }

  Future<void> add(Debt debt) async {
    final docRef = _firestore
        .collection(FirebaseConstants.usersCollection)
        .doc(debt.userId)
        .collection(FirebaseConstants.debtsCollection)
        .doc();

    final data = debt.toJson()..remove('id');
    data['createdAt'] = FieldValue.serverTimestamp();
    data['updatedAt'] = FieldValue.serverTimestamp();

    await docRef.set(data);
  }

  Future<void> update(Debt debt) async {
    final data = debt.toJson()..remove('id');
    data['updatedAt'] = FieldValue.serverTimestamp();

    await _firestore
        .collection(FirebaseConstants.usersCollection)
        .doc(debt.userId)
        .collection(FirebaseConstants.debtsCollection)
        .doc(debt.id)
        .update(data);
  }

  Future<void> delete(String userId, String id) async {
    await _firestore
        .collection(FirebaseConstants.usersCollection)
        .doc(userId)
        .collection(FirebaseConstants.debtsCollection)
        .doc(id)
        .delete();
  }
}
