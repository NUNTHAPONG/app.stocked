import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:stocked/models/portfolio.dart';
import 'package:stocked/pages/detail.dart';
import 'package:stocked/repositories/portfolio.dart';
import 'package:stocked/utils/loading.dart';
import 'package:stocked/utils/number.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  final PortfolioRepo _db = PortfolioRepo();

  toDetail({dynamic data}) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => DetailPage(param: data)));
  }

  int _sort(DataSnapshot a, DataSnapshot b) {
    Portfolio objA = Portfolio.fromJson(a.key!, jsonEncode(a.value));
    Portfolio objB = Portfolio.fromJson(a.key!, jsonEncode(a.value));
    return objB.symbol!.compareTo(objA.symbol!);
  }

  @override
  void initState() {
    super.initState();
    _db.getQuery().keepSynced(true);
  }

  @override
  void dispose() {
    super.dispose();
    // _db.getQuery().keepSynced(false);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: FirebaseAnimatedList(
          query: _db.getQuery(),
          itemBuilder: (BuildContext context, DataSnapshot snapshot,
              Animation<double> animation, int index) {
            Portfolio data =
                Portfolio.fromJson(snapshot.key!, jsonEncode(snapshot.value));
            if (!snapshot.exists) {
              return errorScreen();
            } else {
              return Card(
                child: ListTile(
                  leading: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        data.symbol.toString(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  title: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        data.nameTh != null ? data.nameTh.toString() : '',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: Theme.of(context)
                                .textTheme
                                .labelMedium!
                                .fontSize),
                      ),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'ราคาเฉลี่ย : ${NumberService.formatNumber(data.avgPrice)}',
                        style: TextStyle(
                            fontSize: Theme.of(context)
                                .textTheme
                                .labelSmall!
                                .fontSize),
                      ),
                      Text(
                        'จำนวน : ${NumberService.formatNumber(data.volumn)}',
                        style: TextStyle(
                            fontSize: Theme.of(context)
                                .textTheme
                                .labelSmall!
                                .fontSize),
                      ),
                      Text(
                        'มูลค่า : ${NumberService.formatNumber((data.avgPrice! * data.volumn!))}',
                        style: TextStyle(
                            fontSize: Theme.of(context)
                                .textTheme
                                .labelSmall!
                                .fontSize),
                      ),
                    ],
                  ),
                  onTap: () {
                    toDetail(data: data);
                  },
                ),
              );
            }
          }),
    );
  }
}