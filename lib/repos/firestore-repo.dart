import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pocket_money/models/index.dart';
import 'package:pocket_money/utils/logger.dart';
import 'dart:async';

class FirestoreRepo {
  static const diKey = 'FirestoreRepo';
  final _logger = createLogger(diKey);
  final FirebaseFirestore _instance;

  FirestoreRepo(FirebaseApp app)
      : _instance = FirebaseFirestore.instanceFor(app: app);

  Future<List<Map<String, dynamic>>> _querys(
    String userId,
    Query Function(CollectionReference collection) filter,
  ) async {
    final collection = _instance.collection(userId);
    final query = filter(collection);
    final snapshot = await query.get();
    return snapshot.docs.map((doc) {
      final d = doc.data();
      d['id'] = doc.id;
      d['path'] = doc.reference.path;
      return d;
    }).toList();
  }

  Future<Map<String, dynamic>?> _query(
    String userId,
    String docPath,
  ) async {
    var document = _instance.collection(userId).doc(docPath);
    final snapshot = await document.get();
    if (snapshot.exists) {
      final d = snapshot.data();
      d['id'] = snapshot.id;
      d['path'] = snapshot.reference.path;
      return d;
    }
    return null;
  }

  Future<List<CostItem>> getCostsBetween(
      String userId, int from, int to) async {
    _logger.i('$userId -- $from -- $to');
    final filter = (CollectionReference collection) => collection
        .where('dateStamp', isGreaterThan: from)
        .where('dateStamp', isLessThan: to);
    final result = await _querys(userId, filter);
    _logger.i({'length': result.length, 'fn': 'getCostsBetween'});
    return result.map((map) => CostItem.fromMap(map)).toList();
  }

  Future<CostItem?> getCost(String userId, String id) async {
    final cost = await _query(userId, id);
    if (cost == null) {
      return null;
    }
    return CostItem.fromMap(cost);
  }

  Future<void> updateOrInsert(String userId, CostItem item) async {
    final id = item.id;
    final doc = _instance.collection(userId).doc(id);
    final map = item.toMap();
    map.remove('id');
    await doc.set(map, SetOptions(merge: true));
  }

  Future<void> updateOrInsertMany(String userId, List<CostItem> items) async {
    final futures = items.map(
      (item) => updateOrInsert(userId, item).catchError(
        (err) => _logger.e(
          item,
          err,
          StackTrace.current,
        ),
      ),
    );

    await Future.wait(futures);
  }
}
