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

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 13),
          child: Row(
            children: [
              Text(
                _getLabelText(),
                style: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.normal),
              ),
              Text(
                _isRequireInput() ? ' *' : '',
                style: const TextStyle(
                    fontSize: 14,
                    color: Colors.red,
                    fontWeight: FontWeight.normal),
              ),
            ],
          ),
        ),
        TextFormField(
          controller: widget.controller,
          readOnly: true,
          enableInteractiveSelection: false,
          focusNode: AlwaysDisabledFocusNode(),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: MultiValidator(widget.validate),
          textAlign: TextAlign.right,
          style: const TextStyle(
            fontSize: 14,
          ),
          decoration: InputDecoration(
              suffixIcon: IconButton(
                  onPressed: () {
                    showCupertinoModalPopup(
                        context: context,
                        builder: (BuildContext context) => SizedBox(
                              height: 250,
                              child: CupertinoDatePicker(
                                backgroundColor: Colors.white,
                                initialDateTime: dateTime,
                                onDateTimeChanged: (DateTime newTime) {
                                  setState(() => dateTime = newTime);
                                  widget.controller.text =
                                      DateTimeService.formatDate(dateTime);
                                },
                                use24hFormat: true,
                                mode: CupertinoDatePickerMode.date,
                              ),
                            ));
                  },
                  icon: const Icon(Icons.date_range))),
          onChanged: widget.onChanged != null ? widget.onChanged! : null,
          onSaved: (value) => widget.onSaved(DateTime.tryParse(value.toString())),
        ),
      ],
    );
  }
}
