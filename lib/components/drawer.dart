import 'package:flutter/material.dart';
import 'package:stocked/components/side_bar_tile.dart';
import 'package:stocked/utils/routes.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.indigo,
      width: MediaQuery.of(context).size.width * 0.8,
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.white24,
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
              ),
              title: Text('ชื่อผู้ใช้'),
              subtitle: Text('รายละเอียด'),
              textColor: Colors.white,
            ),
            const Divider(
              color: Colors.white,
            ),
            ...menus
                .map((e) => SideBarTile(
                      menu: e,
                      isActive: false,
                    ))
                .toList(),
          ],
        ),
      ),
    );
  }
}
