import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:stocked/models/portfolio.dart';
import 'package:stocked/repositories/portfolio.dart';

class Dashboard {}

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List<Portfolio> _data = [];
  final PortfolioRepo _port = PortfolioRepo();

  _loadData() async {
    final snapshot = await _port.getQuery().get();
    _data = snapshot.children
        .map(
          (e) => Portfolio.fromJson(e.key!, jsonEncode(e.value)),
        )
        .toList();
    log('message');
  }

  @override
  void initState() {
    super.initState();
    // _loadData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 200,
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: const Text('data'),
        ),
      ],
    );
  }

  Widget sectionHeader() {
    return Stack(
      children: [
        Container(
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  '100,000',
                  style: TextStyle(fontSize: 64, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
        ),
        Container(
          width: 200,
          height: 200,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                bottomLeft: Radius.circular(20),
                topRight: Radius.circular(80),
                bottomRight: Radius.circular(80)),
            color: Colors.indigo,
          ),
          child: Image.asset(
            'assets/lottie/piggy-bank.png',
            width: 20,
            height: 20,
          ),
        ),
      ],
    );
  }
}
