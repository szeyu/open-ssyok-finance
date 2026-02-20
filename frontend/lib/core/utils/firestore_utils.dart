import 'package:cloud_firestore/cloud_firestore.dart';

/// Converts any Firestore [Timestamp] values in [data] to ISO-8601 strings
/// so that Freezed / json_serializable generated fromJson can parse them.
Map<String, dynamic> normalizeFirestoreData(Map<String, dynamic> data) {
  return data.map((key, value) {
    if (value is Timestamp) {
      return MapEntry(key, value.toDate().toIso8601String());
    }
    return MapEntry(key, value);
  });
}
