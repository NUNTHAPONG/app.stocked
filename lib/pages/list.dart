import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:stocked/models/portfolio.dart';
import 'package:stocked/pages/detail.dart';
import 'package:stocked/repositories/portfolio.dart';
import 'package:stocked/utils/loading.dart';

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
          // defaultChild: loadingScreen(),
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
                  title: Text(data.key.toString()),
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(data.symbol.toString()),
                      Text(data.volumn.toString()),
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

// return StreamBuilder<QuerySnapshot>(
//   stream: _listStream,
//   builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//     if (snapshot.hasError) {
//       return errorScreen();
//     }

//     if (snapshot.connectionState == ConnectionState.waiting) {
//       return loadingScreen();
//     }

//     return ListView(
//       children: snapshot.data!.docs.map((DocumentSnapshot document) {
//         Map<String, dynamic> data =
//             document.data()! as Map<String, dynamic>;
//         return ListTile(
//           title: Text(data['id'].toString()),
//           subtitle: Text(data['title'].toString()),
//           onTap: () {
//             toDetail(data: data);
//           },
//         );
//       }).toList(),
//     );
//   },
// );
