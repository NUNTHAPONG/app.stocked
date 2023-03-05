import 'package:flutter/material.dart';

class SecondaryAppBar extends StatefulWidget {
  const SecondaryAppBar({super.key, this.title});

  final String? title;

  @override
  State<SecondaryAppBar> createState() => _SecondaryAppBarState();
}

class _SecondaryAppBarState extends State<SecondaryAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: Builder(
        builder: (BuildContext context) {
          return IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 28,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            tooltip: 'Menu',
          );
        },
      ),
      backgroundColor: Colors.white10,
      title: Text(
        widget.title ?? '',
        style: const TextStyle(color: Colors.black),
      ),
      centerTitle: true,
      elevation: 0,
    );
  }
}
