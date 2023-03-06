import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:stocked/app.dart';
import 'package:stocked/configs/firebase/firebase_options.dart';
import 'package:stocked/utils/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Stocked App',
      theme: AppTheme.theme,
      home: const AppPage(),
    );
  }
}
