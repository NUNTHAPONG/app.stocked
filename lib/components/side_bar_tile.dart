import 'package:flutter/material.dart';
import 'package:stocked/app.dart';

class AppNavigationItem {
  final String key;
  final String title;
  final IconData icon;
  final Widget? screen;

  AppNavigationItem(
      {required this.key,
      required this.title,
      required this.icon,
      this.screen});
}

class SideBarTile extends StatelessWidget {
  const SideBarTile({super.key, required this.menu, this.isActive});

  final AppNavigationItem menu;
  final bool? isActive;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        if (menu.key == "root") {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const AppPage()));
        } else {
          if (menu.screen != null) {
            Navigator.pop(context);
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => menu.screen!));
          } else {
            Navigator.pop(context);
          }
        }
      },
      leading: SizedBox(
        height: 34,
        width: 34,
        child: Icon(
          menu.icon,
          color: Colors.white,
        ),
      ),
      title: Text(
        menu.title,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
