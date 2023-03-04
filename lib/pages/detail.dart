import 'package:flutter/material.dart';
import 'package:stocked/components/secondary_app_bar.dart';
import 'package:stocked/models/portfolio.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key, this.param});

  final Portfolio? param;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late Portfolio data = Portfolio();

  @override
  void initState() {
    super.initState();
    if (widget.param != null) {
      data = widget.param!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: SecondaryAppBar(),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Center(
          child: Column(
            children: [
              Row(
                children: [
                  const Text(
                    'Key : ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(data.key != null ? data.key.toString() : '')
                ],
              ),
              Row(
                children: [
                  const Text(
                    'Symbol : ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(data.symbol != null ? data.symbol.toString() : '')
                ],
              ),
              Row(
                children: [
                  const Text(
                    'Volumn : ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(data.volumn != null ? data.volumn.toString() : '')
                ],
              ),
              Row(
                children: [
                  const Text(
                    'Avg. Price : ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(data.avgPrice != null ? data.avgPrice.toString() : '')
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
