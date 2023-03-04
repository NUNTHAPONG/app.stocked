import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:stocked/utils/form.dart';

class InputNumber extends StatefulWidget {
  InputNumber(
      {super.key,
      required this.controller,
      this.label,
      this.icon,
      this.digits,
      this.disable,
      this.onChanged,
      required this.onSaved,
      required this.validate});

  TextEditingController controller;
  String? label;
  IconData? icon;
  int? digits;
  bool? disable;
  Function(double?) onSaved;
  Function(String)? onChanged;
  List<FieldValidator> validate;

  @override
  State<InputNumber> createState() => _InputNumberState();
}

class _InputNumberState extends State<InputNumber> {
  final FocusNode _onFocus = FocusNode();
  int digits = 2;

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
  initState() {
    super.initState();
    digits = widget.digits ?? 2;
    _onFocus.addListener(() {
      if (!_onFocus.hasFocus && !widget.controller.text.contains('.') && digits > 0) {
        widget.controller.text = widget.controller.text.isNotEmpty
            ? '${widget.controller.text}.${'0' * digits}'
            : '0.${'0' * digits}';
      }
    });
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
          keyboardType: TextInputType.number,
          focusNode: _onFocus,
          enabled: widget.disable != null ? !widget.disable! : true,
          textAlign: TextAlign.right,
          inputFormatters: <TextInputFormatter>[DecimalTextInputFormatter(digits: digits)],
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: MultiValidator(widget.validate),
          style: const TextStyle(
            fontSize: 14,
          ),
          decoration: InputDecoration(
            focusColor: Colors.white,
            prefixIcon: widget.icon != null
                ? Icon(
                    widget.icon,
                    color: Colors.grey,
                  )
                : null,
            fillColor: Colors.grey,
          ),
          onChanged: widget.onChanged != null ? widget.onChanged! : null,
          onSaved: (value) => widget.onSaved(double.tryParse(value.toString())),
        ),
      ],
    );
  }
}
