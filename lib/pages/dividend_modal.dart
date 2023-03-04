import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:lottie/lottie.dart';
import 'package:stocked/components/input_date.dart';
import 'package:stocked/components/input_number.dart';
import 'package:stocked/components/input_text.dart';
import 'package:stocked/models/dividend.dart';
import 'package:stocked/repositories/dividend.dart';
import 'package:stocked/utils/datetime.dart';
import 'package:stocked/utils/form.dart';

class DividendModal extends StatefulWidget {
  const DividendModal({super.key});

  @override
  State<DividendModal> createState() => _DividendModalState();
}

class _DividendModalState extends State<DividendModal> {
  DividendRepo _db = DividendRepo();
  Dividend _data = Dividend();
  final _formKey = GlobalKey<FormState>();
  final _symbolController = TextEditingController();
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
    _netAmtController.text = (amt - wht).toString();
  }

  @override
  Widget build(BuildContext context) {
    void save() {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        // log(_data.toJson());
        _db.saveChanges(_data);
        Navigator.pop(context);
      } else {
        return;
      }
    }

    return AlertDialog(
      scrollable: true,
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  InputText(
                    controller: _symbolController,
                    label: 'สัญลักษณ์',
                    validate: [RequiredValidator(errorText: 'กรอกมาสักอย่าง')],
                    onSaved: (value) => _data.symbol = value,
                  ),
                  InputDate(
                    controller: _dateController,
                    label: 'วันที่จ่ายปันผล',
                    validate: [],
                    onSaved: (value) {
                      _data.payDate = value;
                    },
                  ),
                  InputNumber(
                    controller: _amtController,
                    label: 'จำนวน',
                    validate: [RequiredValidator(errorText: 'กรอกมาสักอย่าง')],
                    onChanged: _setNetAmt,
                    onSaved: (value) => _data.amt = value,
                  ),
                  InputNumber(
                    controller: _whtController,
                    label: 'หัก ณ ที่จ่าย',
                    validate: [],
                    onChanged: _setNetAmt,
                    onSaved: (value) => _data.wht = value,
                  ),
                  InputNumber(
                    controller: _netAmtController,
                    label: 'จำนวนสุทธิ',
                    disable: true,
                    validate: [],
                    onSaved: (value) => _data.netAmt = value,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 35),
                    child: ElevatedButton(
                      onPressed: save,
                      child: const Text("บันทึกข้อมูล"),
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
