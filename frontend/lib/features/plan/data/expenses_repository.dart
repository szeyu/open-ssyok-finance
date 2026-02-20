import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ssyok_finance/core/constants/firebase_constants.dart';
import 'package:ssyok_finance/core/utils/firestore_utils.dart';
import 'package:ssyok_finance/features/plan/domain/expense.dart';

class ExpensesRepository {
  final FirebaseFirestore _firestore;

  ExpensesRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Stream<List<Expense>> watchAll(String userId) {
    return _firestore
        .collection(FirebaseConstants.usersCollection)
        .doc(userId)
        .collection(FirebaseConstants.expensesCollection)
        .orderBy('category')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Expense.fromJson(normalizeFirestoreData({...doc.data(), 'id': doc.id})))
            .toList());
  }

  Future<void> add(Expense expense) async {
    final docRef = _firestore
        .collection(FirebaseConstants.usersCollection)
        .doc(expense.userId)
        .collection(FirebaseConstants.expensesCollection)
        .doc();

    final data = expense.toJson()..remove('id');
    data['createdAt'] = FieldValue.serverTimestamp();
    data['updatedAt'] = FieldValue.serverTimestamp();

    await docRef.set(data);
  }

  Future<void> update(Expense expense) async {
    final data = expense.toJson()..remove('id');
    data['updatedAt'] = FieldValue.serverTimestamp();

    await _firestore
        .collection(FirebaseConstants.usersCollection)
        .doc(expense.userId)
        .collection(FirebaseConstants.expensesCollection)
        .doc(expense.id)
        .update(data);
  }

  Future<void> delete(String userId, String id) async {
    await _firestore
        .collection(FirebaseConstants.usersCollection)
        .doc(userId)
        .collection(FirebaseConstants.expensesCollection)
        .doc(id)
        .delete();
  }
}
