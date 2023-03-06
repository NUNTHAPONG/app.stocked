import 'package:flutter/material.dart';
import 'package:stocked/components/side_bar_tile.dart';
import 'package:stocked/pages/dashboard.dart';
import 'package:stocked/pages/dividend.dart';
import 'package:stocked/pages/list.dart';

List<AppNavigationItem> menus = [
  AppNavigationItem(key: 'root', title: 'หน้าหลัก', icon: Icons.home),
  AppNavigationItem(key: 'list', title: 'รายการ', icon: Icons.list),
  AppNavigationItem(key: 'div', title: 'รายได้', icon: Icons.school),
];

List<AppNavigationItem> pages = [
  AppNavigationItem(
      key: 'root',
      title: 'หน้าหลัก',
      icon: Icons.home,
      screen: const DashboardPage()),
  AppNavigationItem(
      key: 'list', title: 'รายการ', icon: Icons.list, screen: const ListPage()),
  AppNavigationItem(
      key: 'div',
      title: 'เงินปันผล',
      icon: Icons.currency_bitcoin,
      screen: const DividendPage()),
];
