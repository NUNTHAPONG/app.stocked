import 'package:flutter/material.dart';

class AppBarAction {
  String? label;
  IconData? icon;
  Color? color;
  Function()? onPressed;

  AppBarAction({this.label, this.icon, this.color, this.onPressed});
}

class SecondaryAppBar extends StatefulWidget {
  const SecondaryAppBar({super.key, this.title, this.action1, this.action2});

  final String? title;
  final AppBarAction? action1;
  final AppBarAction? action2;

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
            tooltip: 'กลับ',
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
      actions: <Widget>[
        IconButton(
          icon: Icon(
            widget.action2?.icon,
            size: 28,
            color: widget.action2?.color ?? Colors.black,
          ),
          onPressed: widget.action2?.onPressed,
          tooltip: widget.action2?.label,
        ),
        IconButton(
          icon: Icon(
            widget.action1?.icon,
            size: 28,
            color: widget.action1?.color ?? Colors.black,
          ),
          onPressed: widget.action1?.onPressed,
          tooltip: widget.action1?.label,
        ),
      ],
    );
  }
}
