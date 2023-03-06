import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:lottie/lottie.dart';
import 'package:stocked/components/input/input_date.dart';
import 'package:stocked/components/input/input_number.dart';
import 'package:stocked/components/input/input_select.dart';
import 'package:stocked/models/dividend.dart';
import 'package:stocked/repositories/dividend.dart';
import 'package:stocked/utils/datetime.dart';

class DividendModal extends StatefulWidget {
  const DividendModal({super.key, required this.master});

  final Map<String, dynamic> master;

  @override
  State<DividendModal> createState() => _DividendModalState();
}

class _DividendModalState extends State<DividendModal> {
  final DividendRepo _divRepo = DividendRepo();
  final Dividend _data = Dividend();
  final _formKey = GlobalKey<FormState>();
  final _amtController = TextEditingController();
  final _whtController = TextEditingController();
  final _netAmtController = TextEditingController();
  final _dateController =
      TextEditingController(text: DateTimeService.formatDate(DateTime.now()));

  void _setNetAmt(String value) {
    double amt = double.parse(
        _amtController.text.isNotEmpty ? _amtController.text : '0.00');
    double wht = double.parse(
        _whtController.text.isNotEmpty ? _whtController.text : '0.00');
    _netAmtController.text = (amt - wht).toStringAsFixed(2);
  }

  void save() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _divRepo.saveChanges(_data);
      // log(_data.toJson());
      Navigator.pop(context);
    } else {
      return;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _amtController.dispose();
    _whtController.dispose();
    _netAmtController.dispose();
    _dateController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
      content: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(40)),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: <Widget>[
            Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  InputSelect(
                      value: _data.symbol,
                      label: 'สัญลักษณ์',
                      items: widget.master['list']
                          .map<SelectOption>((e) => SelectOption(
                              e.symbol.toString(),
                              '${e.symbol.toString()} : ${e.nameTh.toString()}'))
                          .toList(),
                      onChanged: (value) =>
                          setState(() => _data.symbol = value)),
                  InputDate(
                    controller: _dateController,
                    label: 'วันที่จ่ายปันผล',
                    validate: const <FieldValidator>[],
                    onSaved: (value) => setState(() => _data.payDate = value),
                  ),
                  InputNumber(
                    controller: _amtController,
                    label: 'จำนวน',
                    validate: <FieldValidator>[RequiredValidator(errorText: 'กรอกมาสักอย่าง')],
                    onChanged: _setNetAmt,
                    onSaved: (value) => setState(() => _data.amt = value),
                  ),
                  InputNumber(
                    controller: _whtController,
                    label: 'หัก ณ ที่จ่าย',
                    validate: <FieldValidator>[RequiredValidator(errorText: 'กรอกมาสักอย่าง')],
                    onChanged: _setNetAmt,
                    onSaved: (value) => setState(() => _data.wht = value),
                  ),
                  InputNumber(
                    controller: _netAmtController,
                    label: 'จำนวนสุทธิ',
                    disable: true,
                    validate: <FieldValidator>[
                      PatternValidator(r'^[0-9].+', errorText: 'อย่าาาๆๆๆๆ')
                    ],
                    onSaved: (value) => setState(() => _data.netAmt = value),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 35),
                    child: ElevatedButton(
                      onPressed: save,
                      child: const Text(
                        "บันทึกข้อมูล",
                        style: TextStyle(),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Positioned(
              top: -90,
              child: Lottie.asset('assets/lottie/pig-save.json',
                  width: 76, height: 76, fit: BoxFit.cover),
            ),
          ],
        ),
      ),
    );
  }
}
