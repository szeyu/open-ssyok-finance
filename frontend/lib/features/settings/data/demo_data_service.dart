import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ssyok_finance/core/constants/firebase_constants.dart';

/// Seeds realistic Malaysian financial demo data for live demos.
class DemoDataService {
  final FirebaseFirestore _firestore;

  DemoDataService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Load all demo data for the given user. Wipes existing data first.
  Future<void> loadDemoData(String userId) async {
    await _clearAllData(userId);

    final batch = _firestore.batch();
    final now = DateTime.now();
    final userRef = _firestore
        .collection(FirebaseConstants.usersCollection)
        .doc(userId);

    // ── Assets ────────────────────────────────────────────────────────────
    final assets = <Map<String, dynamic>>[
      {
        'userId': userId,
        'type': 'retirement',
        'name': 'EPF (KWSP)',
        'value': 25800.0,
        'monthlyContribution': 600.0,
        'growthRate': 5.5,
        'isEmergencyFund': false,
        'createdAt': Timestamp.fromDate(now),
        'updatedAt': Timestamp.fromDate(now),
      },
      {
        'userId': userId,
        'type': 'investment',
        'name': 'ASB',
        'value': 10500.0,
        'monthlyContribution': 300.0,
        'growthRate': 6.0,
        'isEmergencyFund': false,
        'createdAt': Timestamp.fromDate(now),
        'updatedAt': Timestamp.fromDate(now),
      },
      {
        'userId': userId,
        'type': 'savings',
        'name': 'Maybank Savings (Emergency)',
        'value': 8000.0,
        'monthlyContribution': 200.0,
        'growthRate': 2.0,
        'isEmergencyFund': true,
        'createdAt': Timestamp.fromDate(now),
        'updatedAt': Timestamp.fromDate(now),
      },
      {
        'userId': userId,
        'type': 'investment',
        'name': 'Versa (Money Market)',
        'value': 3200.0,
        'monthlyContribution': 100.0,
        'growthRate': 3.8,
        'isEmergencyFund': false,
        'createdAt': Timestamp.fromDate(now),
        'updatedAt': Timestamp.fromDate(now),
      },
    ];

    for (final asset in assets) {
      final ref = userRef
          .collection(FirebaseConstants.assetsCollection)
          .doc();
      batch.set(ref, asset);
    }

    // ── Debts ─────────────────────────────────────────────────────────────
    final debts = <Map<String, dynamic>>[
      {
        'userId': userId,
        'type': 'ptptn',
        'name': 'PTPTN Study Loan',
        'balance': 15200.0,
        'interestRate': 1.0,
        'monthlyPayment': 150.0,
        'createdAt': Timestamp.fromDate(now),
        'updatedAt': Timestamp.fromDate(now),
      },
      {
        'userId': userId,
        'type': 'car_loan',
        'name': 'Proton X50 Hire Purchase',
        'balance': 52000.0,
        'interestRate': 3.5,
        'monthlyPayment': 850.0,
        'createdAt': Timestamp.fromDate(now),
        'updatedAt': Timestamp.fromDate(now),
      },
      {
        'userId': userId,
        'type': 'credit_card',
        'name': 'Maybank Visa (Revolving)',
        'balance': 2800.0,
        'interestRate': 18.0,
        'monthlyPayment': 200.0,
        'createdAt': Timestamp.fromDate(now),
        'updatedAt': Timestamp.fromDate(now),
      },
    ];

    for (final debt in debts) {
      final ref = userRef
          .collection(FirebaseConstants.debtsCollection)
          .doc();
      batch.set(ref, debt);
    }

    // ── Goals ─────────────────────────────────────────────────────────────
    final goals = <Map<String, dynamic>>[
      {
        'userId': userId,
        'type': 'emergency_fund',
        'name': '6-Month Emergency Fund',
        'targetAmount': 15000.0,
        'currentAmount': 8000.0,
        'targetDate': Timestamp.fromDate(DateTime(now.year + 1, 6, 30)),
        'createdAt': Timestamp.fromDate(now),
        'updatedAt': Timestamp.fromDate(now),
      },
      {
        'userId': userId,
        'type': 'house',
        'name': 'Down Payment — First Home',
        'targetAmount': 50000.0,
        'currentAmount': 18000.0,
        'targetDate': Timestamp.fromDate(DateTime(now.year + 3, 12, 31)),
        'createdAt': Timestamp.fromDate(now),
        'updatedAt': Timestamp.fromDate(now),
      },
      {
        'userId': userId,
        'type': 'vacation',
        'name': 'Japan Trip',
        'targetAmount': 8000.0,
        'currentAmount': 3500.0,
        'targetDate': Timestamp.fromDate(DateTime(now.year + 1, 3, 1)),
        'createdAt': Timestamp.fromDate(now),
        'updatedAt': Timestamp.fromDate(now),
      },
      {
        'userId': userId,
        'type': 'retirement',
        'name': 'EPF Target II',
        'targetAmount': 500000.0,
        'currentAmount': 25800.0,
        'targetDate': Timestamp.fromDate(DateTime(now.year + 30, 1, 1)),
        'createdAt': Timestamp.fromDate(now),
        'updatedAt': Timestamp.fromDate(now),
      },
    ];

    for (final goal in goals) {
      final ref = userRef
          .collection(FirebaseConstants.goalsCollection)
          .doc();
      batch.set(ref, goal);
    }

    // ── Expenses ──────────────────────────────────────────────────────────
    final expenses = <Map<String, dynamic>>[
      {
        'userId': userId,
        'category': 'food',
        'monthlyAmount': 650.0,
        'inflationRate': 4.0,
        'createdAt': Timestamp.fromDate(now),
        'updatedAt': Timestamp.fromDate(now),
      },
      {
        'userId': userId,
        'category': 'housing',
        'monthlyAmount': 1200.0,
        'inflationRate': 3.0,
        'createdAt': Timestamp.fromDate(now),
        'updatedAt': Timestamp.fromDate(now),
      },
      {
        'userId': userId,
        'category': 'transport',
        'monthlyAmount': 380.0,
        'inflationRate': 3.5,
        'createdAt': Timestamp.fromDate(now),
        'updatedAt': Timestamp.fromDate(now),
      },
      {
        'userId': userId,
        'category': 'healthcare',
        'monthlyAmount': 120.0,
        'inflationRate': 5.0,
        'createdAt': Timestamp.fromDate(now),
        'updatedAt': Timestamp.fromDate(now),
      },
      {
        'userId': userId,
        'category': 'other',
        'monthlyAmount': 400.0,
        'inflationRate': 3.0,
        'createdAt': Timestamp.fromDate(now),
        'updatedAt': Timestamp.fromDate(now),
      },
    ];

    for (final expense in expenses) {
      final ref = userRef
          .collection(FirebaseConstants.expensesCollection)
          .doc();
      batch.set(ref, expense);
    }

    await batch.commit();
  }

  /// Delete all plan data for the given user.
  Future<void> _clearAllData(String userId) async {
    await Future.wait([
      _deleteCollection(userId, FirebaseConstants.assetsCollection),
      _deleteCollection(userId, FirebaseConstants.debtsCollection),
      _deleteCollection(userId, FirebaseConstants.goalsCollection),
      _deleteCollection(userId, FirebaseConstants.expensesCollection),
    ]);
  }

  Future<void> _deleteCollection(String userId, String collection) async {
    final snapshot = await _firestore
        .collection(FirebaseConstants.usersCollection)
        .doc(userId)
        .collection(collection)
        .get();

    if (snapshot.docs.isEmpty) return;

    final batch = _firestore.batch();
    for (final doc in snapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }

  /// Reset all data (same as clearing without reloading).
  Future<void> resetAllData(String userId) async {
    await _clearAllData(userId);
  }
}

