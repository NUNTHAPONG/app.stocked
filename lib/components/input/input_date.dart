import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:stocked/utils/datetime.dart';
import 'package:stocked/utils/form.dart';

class InputDate extends StatefulWidget {
  const InputDate(
      {super.key,
      required this.controller,
      this.label,
      this.disable,
      this.onChanged,
      required this.onSaved,
      required this.validate});

  final TextEditingController controller;
  final String? label;
  final bool? disable;
  final Function(String?)? onChanged;
  final Function(DateTime?) onSaved;
  final List<FieldValidator> validate;

  @override
  State<InputDate> createState() => _InputDateState();
}

class _InputDateState extends State<InputDate> {
  DateTime dateTime = DateTime.now();

  bool _isRequireInput() {
    return widget.validate
        .any((element) => element.runtimeType == RequiredValidator);
  }

  String _getLabelText() {
    if (widget.label != null) {
      return widget.label!;
    } else {
      return '';
    }
  }

  Future<dynamic> _openDatePicker() {
    return showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 250,
                    child: CupertinoDatePicker(
                      backgroundColor: Colors.white,
                      initialDateTime: DateTime.parse(widget.controller.text),
                      onDateTimeChanged: (DateTime newTime) {
                        setState(() => dateTime = newTime);
                      },
                      use24hFormat: true,
                      mode: CupertinoDatePickerMode.date,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'Cancel'),
                        child: const Text('ยกเลิก'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          widget.controller.text =
                              DateTimeService.formatDate(dateTime);
                          return Navigator.pop(context, 'Ok');
                        },
                        child: const Text('ยืนยัน'),
                      ),
                    ],
                  ),
                ],
              ),
              contentTextStyle: TextStyle(
                  fontSize: Theme.of(context).textTheme.labelMedium!.fontSize,
                  fontFamily: 'AppFonts',
                  fontWeight: FontWeight.bold),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      enableInteractiveSelection: false,
      // focusNode: AlwaysDisabledFocusNode(),
      showCursor: false,
      cursorWidth: 0,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: MultiValidator(widget.validate),
      decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
          focusColor: Colors.white,
          fillColor: Colors.grey,
          labelText: _getLabelText(),
          errorStyle: const TextStyle(fontSize: 12),
          suffixIcon: IconButton(
              onPressed: _openDatePicker, icon: const Icon(Icons.date_range))),
      onTap: _openDatePicker,
      onChanged: widget.onChanged != null ? widget.onChanged! : null,
      onSaved: (value) => widget.onSaved(DateTime.tryParse(value.toString())),
    );
  }
}
