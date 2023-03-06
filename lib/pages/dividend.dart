import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:stocked/models/dividend.dart';
import 'package:stocked/repositories/dividend.dart';
import 'package:stocked/utils/datetime.dart';
import 'package:stocked/utils/loading.dart';

class DividendPage extends StatefulWidget {
  const DividendPage({super.key});

  @override
  State<DividendPage> createState() => _DividendPageState();
}

class _DividendPageState extends State<DividendPage> {
  final DividendRepo _divRepo = DividendRepo();

  @override
  void initState() {
    super.initState();
    _divRepo.getQuery().keepSynced(true);
  }

  @override
  void dispose() {
    super.dispose();
    // _divRepo.getQuery().keepSynced(false);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: FirebaseAnimatedList(
          query: _divRepo.getQuery(),
          sort: (b, a) => Dividend.fromJson(a.key!, jsonEncode(a.value))
              .payDate!
              .compareTo(
                  Dividend.fromJson(b.key!, jsonEncode(b.value)).payDate!),
          itemBuilder: (BuildContext context, DataSnapshot snapshot,
              Animation<double> animation, int index) {
            Dividend data =
                Dividend.fromJson(snapshot.key!, jsonEncode(snapshot.value));
            if (!snapshot.exists) {
              return errorScreen();
            } else {
              return Card(
                child: ListTile(
                  title: Text(data.key.toString()),
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(data.symbol.toString()),
                      Text(DateTimeService.formatDate(data.payDate!)),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.redAccent,
                    ),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              removeWidget(context, data));
                    },
                  ),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: ((context) => detailWidget(context, data)));
                  },
                ),
              );
            }
          }),
    );
  }

  Widget detailWidget(BuildContext context, Dividend data) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      title: const Text('รายละเอียดการจ่ายปันผล'),
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.15,
        child: Stack(
          clipBehavior: Clip.none,
          children: <Widget>[
            Positioned(
              right: -140,
              top: -190,
              child: InkResponse(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 36,
                  height: 36,
                  margin: const EdgeInsets.all(100.0),
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      shape: BoxShape.circle),
                  child: const Center(
                    child: Text(
                      'x',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      data.symbol!,
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'จำนวนสุทธิ : ${data.netAmt!.toStringAsFixed(2)}',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Text(
                        'จำนวนเงิน ',
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            fontWeight: FontWeight.normal),
                      ),
                      Text(
                        '${data.amt!.toStringAsFixed(2)} บาท',
                        style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Text(
                      'ภาษีหัก ณ ที่ จ่าย ',
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontWeight: FontWeight.normal),
                    ),
                    Text(
                      '${data.wht!.toStringAsFixed(2)} บาท',
                      style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
                Text(
                  'จ่ายเมื่อวันที่ ${DateTimeService.formatDate(data.payDate!)}',
                  style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontWeight: FontWeight.normal),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget removeWidget(BuildContext context, Dividend data) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
      title: const Text('ลบข้อมูล'),
      content: const Text('ต้องการลบข้อมูลการจ่ายปันผลใช่หรือไม่'),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: Text(
                'ยกเลิก',
                style: TextStyle(
                    fontSize:
                        Theme.of(context).textTheme.labelMedium!.fontSize),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _divRepo.remove(data.key!);
                return Navigator.pop(context, 'Cancel');
              },
              child: Text(
                'ยืนยัน',
                style: TextStyle(
                    fontSize:
                        Theme.of(context).textTheme.labelMedium!.fontSize),
              ),
            ),
          ],
        )
      ],
      actionsPadding: const EdgeInsets.only(bottom: 20),
    );
  }
}
