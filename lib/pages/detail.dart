import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:stocked/components/input/input_number.dart';
import 'package:stocked/components/input/input_text.dart';
import 'package:stocked/components/secondary_app_bar.dart';
import 'package:stocked/models/portfolio.dart';
import 'package:stocked/utils/form.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key, this.param});

  final Portfolio? param;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late Portfolio _data = Portfolio();

  final _formKey = GlobalKey<FormState>();
  final _symbolController = TextEditingController();
  final _nameThController = TextEditingController();
  final _nameEnController = TextEditingController();
  final _categoryController = TextEditingController();
  final _volumnController = TextEditingController();
  final _avgPriceController = TextEditingController();

  void _save() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // _divRepo.saveChanges(_data);
      log(_data.toJson());
      Navigator.pop(context);
    } else {
      return;
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.param != null) {
      _data = widget.param!;
      _symbolController.text = FormService.controllerText(_data.symbol);
      _nameThController.text = FormService.controllerText(_data.nameTh);
      _nameEnController.text = FormService.controllerText(_data.nameEn);
      _categoryController.text = FormService.controllerText(_data.category);
      _volumnController.text = FormService.controllerText(_data.volumn);
      _avgPriceController.text = FormService.controllerText(_data.avgPrice);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _symbolController.dispose();
    _nameThController.dispose();
    _nameEnController.dispose();
    _categoryController.dispose();
    _volumnController.dispose();
    _avgPriceController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: SecondaryAppBar(
            title: 'รายละเอียด',
            action1: AppBarAction(
              label: 'บันทึก',
              icon: Icons.save,
              onPressed: _save,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: <Widget>[
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    InputText(
                      controller: _symbolController,
                      label: 'สัญลักษณ์',
                      validate: <FieldValidator>[
                        RequiredValidator(errorText: 'กรอกมาสักอย่าง')
                      ],
                      onSaved: (value) => setState(() => _data.symbol = value),
                    ),
                    InputText(
                      controller: _nameThController,
                      label: 'ชื่อหลักทรัพย์ (ภาษาไทย)',
                      validate: <FieldValidator>[
                        RequiredValidator(errorText: 'กรอกมาสักอย่าง')
                      ],
                      onSaved: (value) => setState(() => _data.nameTh = value),
                    ),
                    InputText(
                      controller: _nameEnController,
                      label: 'ชื่อหลักทรัพย์ (English)',
                      validate: const <FieldValidator>[],
                      onSaved: (value) => setState(() => _data.nameEn = value),
                    ),
                    InputText(
                      controller: _categoryController,
                      label: 'กลุ่มอุตสาหกรรม',
                      validate: const <FieldValidator>[],
                      onSaved: (value) =>
                          setState(() => _data.category = value),
                    ),
                    InputNumber(
                      controller: _avgPriceController,
                      label: 'ราคาเฉลี่ย (บาท)',
                      validate: <FieldValidator>[
                        RequiredValidator(errorText: 'กรอกมาสักอย่าง')
                      ],
                      onSaved: (value) =>
                          setState(() => _data.avgPrice = value),
                    ),
                    InputNumber(
                      controller: _volumnController,
                      label: 'จำนวน',
                      validate: <FieldValidator>[
                        RequiredValidator(errorText: 'กรอกมาสักอย่าง')
                      ],
                      onSaved: (value) => setState(() => _data.volumn = value),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
