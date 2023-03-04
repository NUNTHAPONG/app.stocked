import 'package:firebase_database/firebase_database.dart';
import 'package:stocked/models/dividend.dart';
import 'package:stocked/utils/firebase.dart';

abstract class DividendItf {
  Query getQuery();

  Future<String?> saveChanges(Dividend data);

  Future<void> remove(String key);
}

class DividendRepo implements DividendItf {
  final DatabaseReference _dbRef = AppDatabase.root.child('stDivd');

  @override
  Query getQuery() {
    return _dbRef.orderByKey();
  }

  @override
  Future<void> remove(String key) {
    return _dbRef.child(key).remove();
  }

  @override
  Future<String?> saveChanges(Dividend data) async {
    DatabaseReference newRef = _dbRef.push();
    await newRef.set(data.toMap());
    return newRef.key;
  }
}
