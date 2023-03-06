import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:stocked/models/dividend.dart';
import 'package:stocked/models/portfolio.dart';
import 'package:stocked/repositories/dividend.dart';
import 'package:stocked/repositories/portfolio.dart';
import 'package:stocked/utils/datetime.dart';
import 'package:stocked/utils/number.dart';

class Dashboard {}

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool _isShowBalance = true;
  final PortfolioRepo _portRepo = PortfolioRepo();
  List<Portfolio> _portList = [];
  final DividendRepo _divRepo = DividendRepo();
  List<Dividend> _divList = [];

  double sum(double a, double b) => a + b;

  double _getPortSummary(List<Portfolio> data) {
    double result = 0;
    if (data.isNotEmpty) {
      result = data.map((e) => e.volumn! * e.avgPrice!).reduce(sum);
    }
    return result;
  }

  double _getDivdSummary(List<Dividend> data) {
    double result = 0;
    if (data.isNotEmpty) {
      result = data
          .where((element) => element.payDate!.month == DateTime.now().month)
          .map((e) => e.netAmt!)
          .reduce(sum);
    }
    return result;
  }

  List<Portfolio> _getPieData(List<Portfolio> data) {
    List<Portfolio> result = [];

    sortByAmtDesc(Portfolio b, Portfolio a) =>
        (a.volumn! * a.avgPrice!).compareTo((b.volumn! * b.avgPrice!));

    data.sort(sortByAmtDesc);
    if (data.isNotEmpty) {
      result = data.sublist(0, 3);
      List<Portfolio> tails = data.sublist(3);
      Portfolio others = Portfolio(
          symbol: 'Others',
          volumn: tails.map((e) => e.volumn!).reduce(sum),
          avgPrice: tails.map((e) => e.avgPrice!).reduce(sum) / tails.length);
      result.add(others);
    } else {
      result = data;
    }
    result.sort(sortByAmtDesc);

    return result;
  }

  @override
  void initState() {
    super.initState();
    _divRepo.getQuery().get().then((event) {
      _divList = event.children
          .map(
            (e) => Dividend.fromJson(e.key!, jsonEncode(e.value)),
          )
          .toList();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _portRepo.getQuery().get().asStream(),
        builder: (BuildContext context, AsyncSnapshot<DataSnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Container();
          } else {
            _portList = snapshot.data!.children
                .map(
                  (e) => Portfolio.fromJson(e.key!, jsonEncode(e.value)),
                )
                .toList();
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  cardHeader(),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      summaryPie(_getPieData(_portList)),
                      dividendCrad(),
                    ],
                  ),
                ],
              ),
            );
          }
        });
  }

  Widget dividendCrad() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text(
                        'เงินปันผลรวม (${DateTimeService.getThMonthName(DateTime.now().month, true)}) ',
                        style:
                            const TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        NumberService.formatNumber(_getDivdSummary(_divList)),
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        ' บาท',
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
              const Divider(),
              // const Text('จ่ายสูงสุด 3 อันดับเเรก'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(_divList.length.toString()),
                  const Text('data'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const <Widget>[
                  Text('data'),
                  Text('data'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const <Widget>[
                  Text('data'),
                  Text('data'),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget summaryPie(List<Portfolio> data) {
    List colors = [
      Colors.indigo[800],
      Colors.indigo[500],
      Colors.indigo[200],
      Colors.grey[200]
    ];
    double sum = data
        .map((e) => (e.volumn! * e.avgPrice!))
        .reduce((value, element) => value + element);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          SizedBox(
            width: 120,
            height: 100,
            child: PieChart(PieChartData(
                sections: data
                    .map(
                      (e) => PieChartSectionData(
                          value: (e.volumn! * e.avgPrice!) * 100 / sum,
                          color: colors[data.indexOf(e)],
                          radius: 18,
                          showTitle: false),
                    )
                    .toList())),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ...data.map((e) {
                double amt = (e.volumn! * e.avgPrice!);
                double ratio = ((e.volumn! * e.avgPrice!) * 100 / sum);
                return Indicator(
                  label: _isShowBalance
                      ? '${e.symbol.toString()} ~ ${NumberService.formatNumber(amt)} (${ratio.toStringAsFixed(2)}%)'
                      : '${e.symbol.toString()} ~ ${ratio.toStringAsFixed(2)}%',
                  color: colors[data.indexOf(e)],
                );
              })
            ],
          ),
        ],
      ),
    );
  }

  Widget cardHeader() {
    return Card(
      color: Theme.of(context).primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                const Text(
                  'จำนวนเงินรวม',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                IconButton(
                  onPressed: () => {
                    setState(
                      () => _isShowBalance = !_isShowBalance,
                    )
                  },
                  icon: _isShowBalance
                      ? const Icon(Icons.visibility)
                      : const Icon(Icons.visibility_off),
                  iconSize: 20,
                  color: Colors.white,
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  _isShowBalance
                      ? NumberService.formatNumber(_getPortSummary(_portList))
                      : '******',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 48,
                      fontWeight: FontWeight.bold),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class Indicator extends StatelessWidget {
  const Indicator({super.key, required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.all(Radius.circular(100))),
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 14,
          ),
        )
      ],
    );
  }
}
