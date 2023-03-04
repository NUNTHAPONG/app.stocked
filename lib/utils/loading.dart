import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:stocked/models/portfolio.dart';

Widget loadingScreen() {
  return Container(
    alignment: Alignment.center,
    child: Lottie.asset(
      "assets/lottie/loading.json",
      fit: BoxFit.cover,
    ),
  );
}

Widget errorScreen() {
  return Container(
    alignment: Alignment.center,
    child: Lottie.asset(
      "assets/lottie/error.json",
      fit: BoxFit.cover,
    ),
  );
}

Widget callApi(Future<dynamic> fetchData) {
  Future<dynamic> fetchData() async {
    final res =
        await http.get(Uri.parse('https://jsonplaceholder.typicode.com/todos'));
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      throw Exception('Failed to load');
    }
  }

  return FutureBuilder<dynamic>(
    future: fetchData(),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        List<dynamic> todos = snapshot.data;
        return ListView.builder(
          itemCount: todos.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              child: ListTile(
                title: Text(
                    '${todos.elementAt(index)['id']} - ${todos.elementAt(index)['title']}'),
                onTap: () {
                  // toDetail(data: todos.elementAt(index));
                },
              ),
            );
          },
        );
      } else if (snapshot.hasError) {
        return errorScreen();
      }
      return loadingScreen();
    },
  );
}

initData() async {
  List<Portfolio> _listData = [
    Portfolio(symbol: 'KKP', category: 'Banking', volumn: 500, avgPrice: 68.82),
    Portfolio(symbol: 'LH', category: 'Property', volumn: 600, avgPrice: 8.78),
    Portfolio(
        symbol: 'SAT', category: 'Industrials', volumn: 500, avgPrice: 20.8),
    Portfolio(
        symbol: 'SIRI', category: 'Property ', volumn: 400, avgPrice: 1.07),
    Portfolio(symbol: 'TDEX', category: 'ETF', volumn: 2500, avgPrice: 9.55),
    Portfolio(
        symbol: 'TISCO', category: 'Banking', volumn: 200, avgPrice: 89.53),
    Portfolio(
        symbol: 'TKN',
        category: 'Food & Beverage',
        volumn: 400,
        avgPrice: 9.52),
  ];

  for (var element in _listData) {
    log(element.symbol.toString());
    // String? key = await _port.saveChanges(element);
    // log(key!);
  }
}
