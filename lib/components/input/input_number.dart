import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:stocked/utils/form.dart';

class InputNumber extends StatefulWidget {
  const InputNumber(
      {super.key,
      required this.controller,
      this.label,
      this.icon,
      this.digits,
      this.disable,
      this.onChanged,
      required this.onSaved,
      required this.validate});

  final TextEditingController controller;
  final String? label;
  final IconData? icon;
  final int? digits;
  final bool? disable;
  final Function(double?) onSaved;
  final Function(String)? onChanged;
  final List<FieldValidator> validate;

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
      if (!_onFocus.hasFocus &&
          !widget.controller.text.contains('.') &&
          digits > 0) {
        widget.controller.text = widget.controller.text.isNotEmpty
            ? '${widget.controller.text}.${'0' * digits}'
            : '0.${'0' * digits}';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      focusNode: widget.disable != null && widget.disable!
          ? AlwaysDisabledFocusNode()
          : _onFocus,
      // enabled: widget.disable != null ? !widget.disable! : true,
      inputFormatters: <TextInputFormatter>[
        DecimalTextInputFormatter(digits: digits)
      ],
      autovalidateMode: AutovalidateMode.onUserInteraction,
      enableInteractiveSelection: false,
      validator: MultiValidator(widget.validate),
      style: const TextStyle(
        color: Colors.black,
      ),
      decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
          focusColor: Colors.white,
          prefixIcon: widget.icon != null
              ? Icon(
                  widget.icon,
                  color: Colors.grey,
                )
              : null,
          fillColor: Colors.grey,
          labelText: _getLabelText(),
          errorStyle: const TextStyle(fontSize: 12)),
      onChanged: widget.onChanged != null ? widget.onChanged! : null,
      onSaved: (value) => widget.onSaved(double.tryParse(value.toString())),
    );
  }
}
