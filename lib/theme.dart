import 'package:flutter/material.dart';
import 'package:stocked/app.dart';

class AppTheme extends StatelessWidget {
  const AppTheme({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Stocked App',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        fontFamily: 'AppFonts',
        splashColor: Colors.transparent,
      ),
      home: const AppPage(),
    );
  }
}
