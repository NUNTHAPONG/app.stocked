import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:stocked/components/primary_app_bar.dart';
import 'package:stocked/components/drawer.dart';
import 'package:stocked/models/portfolio.dart';
import 'package:stocked/pages/detail.dart';
import 'package:stocked/pages/dividend_modal.dart';
import 'package:stocked/repositories/portfolio.dart';
import 'package:stocked/utils/routes.dart';

class AppPage extends StatefulWidget {
  const AppPage({super.key});

  final String title = 'Home Page';

  @override
  State<AppPage> createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> with SingleTickerProviderStateMixin {
  final PortfolioRepo _portRepo = PortfolioRepo();
  final List<Portfolio> _portList = [];
  late final StreamSubscription _onPortAdd;

  void toDetail({dynamic data}) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => DetailPage(param: data)));
  }

  void toAddDividend() {
    showDialog(
        context: context,
        builder: ((context) => DividendModal(
              master: {"list": _portList},
            )));
  }

  int _selectedPageIndex = 0;

  void _onChangePages(int index) {
    if (index == _selectedPageIndex) {
      return;
    } else {
      setState(() {
        _selectedPageIndex = index;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _onPortAdd = _portRepo.getQuery().onChildAdded.listen((event) {
      _portList.add(Portfolio.fromJson(
          event.snapshot.key!, jsonEncode(event.snapshot.value)));
    });
  }

  @override
  void dispose() {
    super.dispose();
    _onPortAdd.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: PrimaryAppBar(title: pages.elementAt(_selectedPageIndex).title,),
        ),
        drawer: const AppDrawer(),
        body: pages.elementAt(_selectedPageIndex).screen,
        floatingActionButton: floatingActionButton(),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          showUnselectedLabels: false,
          currentIndex: _selectedPageIndex,
          selectedItemColor: Theme.of(context).primaryColor,
          onTap: _onChangePages,
          items: [
            ...pages
                .map((e) => BottomNavigationBarItem(
                    icon: Icon(e.icon), label: e.title, tooltip: e.title))
                .toList()
          ],
        ));
  }

  Widget floatingActionButton() {
    bool isLastPage = _selectedPageIndex != (pages.length - 1);
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      transitionBuilder: (Widget child, Animation<double> animation) {
        final tween = TweenSequence([
          TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.1), weight: 1),
          TweenSequenceItem(tween: Tween(begin: 1.1, end: 1.0), weight: 1),
        ]);
        final angle = Tween(begin: 0 / 360, end: -360 / 360);
        return RotationTransition(
          turns: isLastPage
              ? angle.animate(animation)
              : angle.animate(ReverseAnimation(animation)),
          alignment: Alignment.center,
          child: ScaleTransition(
            scale: tween.animate(animation),
            child: child,
          ),
        );
      },
      child: isLastPage
          ? FloatingActionButton(
              key: UniqueKey(),
              onPressed: () {
                toDetail();
              },
              tooltip: 'เพิ่มข้อมูลหุ้น',
              child: const Icon(Icons.edit_note))
          : FloatingActionButton(
              key: UniqueKey(),
              onPressed: () {
                toAddDividend();
              },
              tooltip: 'เพิ่มการจ่ายปันผล',
              child: const Icon(Icons.currency_bitcoin),
            ),
    );
  }
}
