import 'package:firebase_database/firebase_database.dart';
import 'package:stocked/models/portfolio.dart';
import 'package:stocked/utils/firebase.dart';

abstract class PortfolioItf {
  Query getQuery();

  Future<String?> saveChanges(Portfolio data);

  Future<void> remove(String key);
}

class PortfolioRepo implements PortfolioItf {
  final DatabaseReference _dbRef = AppDatabase.root.child('stPort');

  @override
  Query getQuery() {
    return _dbRef.orderByKey();
  }

  @override
  Future<void> remove(String key) {
    return _dbRef.child(key).remove();
  }

  @override
  Future<String?> saveChanges(Portfolio data) async {
    DatabaseReference newRef = _dbRef.push();
    await newRef.set(data.toMap());
    return newRef.key;
  }
}
