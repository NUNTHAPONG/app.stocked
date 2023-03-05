
import 'package:firebase_database/firebase_database.dart';
import 'package:stocked/configs/firebase/firebase_options.dart';

class AppDatabase {
  static final DatabaseReference root =
      FirebaseDatabase.instance.ref(DefaultFirebaseOptions.rootPath);
}