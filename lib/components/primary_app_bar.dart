import 'package:flutter/material.dart';

class PrimaryAppBar extends StatefulWidget {
  const PrimaryAppBar({super.key});

  @override
  State<PrimaryAppBar> createState() => _PrimaryAppBarState();
}

class _PrimaryAppBarState extends State<PrimaryAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: Builder(
        builder: (BuildContext context) {
          return IconButton(
            icon: const Icon(
              Icons.menu,
              size: 28,
              color: Colors.black,
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            tooltip: 'Menu',
          );
        },
      ),
      backgroundColor: Colors.white10,
      // title: const Text(
      //   'My App',
      //   style: TextStyle(color: Colors.black),
      // ),
      centerTitle: true,
      elevation: 0,
    );
  }
}
