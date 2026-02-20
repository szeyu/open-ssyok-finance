import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ssyok_finance/core/constants/firebase_constants.dart';
import 'package:ssyok_finance/core/utils/firestore_utils.dart';
import 'package:ssyok_finance/features/plan/domain/asset.dart';

class AssetsRepository {
  final FirebaseFirestore _firestore;

  AssetsRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Stream<List<Asset>> watchAll(String userId) {
    return _firestore
        .collection(FirebaseConstants.usersCollection)
        .doc(userId)
        .collection(FirebaseConstants.assetsCollection)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Asset.fromJson(normalizeFirestoreData({...doc.data(), 'id': doc.id})))
            .toList());
  }

  Future<void> add(Asset asset) async {
    final docRef = _firestore
        .collection(FirebaseConstants.usersCollection)
        .doc(asset.userId)
        .collection(FirebaseConstants.assetsCollection)
        .doc();

    final data = asset.toJson()..remove('id');
    data['createdAt'] = FieldValue.serverTimestamp();
    data['updatedAt'] = FieldValue.serverTimestamp();

    await docRef.set(data);
  }

  Future<void> update(Asset asset) async {
    final data = asset.toJson()..remove('id');
    data['updatedAt'] = FieldValue.serverTimestamp();

    await _firestore
        .collection(FirebaseConstants.usersCollection)
        .doc(asset.userId)
        .collection(FirebaseConstants.assetsCollection)
        .doc(asset.id)
        .update(data);
  }

  Future<void> delete(String userId, String id) async {
    await _firestore
        .collection(FirebaseConstants.usersCollection)
        .doc(userId)
        .collection(FirebaseConstants.assetsCollection)
        .doc(id)
        .delete();
  }
}
