import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';

class InputText extends StatefulWidget {
  const InputText(
      {super.key,
      required this.controller,
      this.label,
      this.icon,
      this.disable,
      this.onChanged,
      required this.onSaved,
      required this.validate});

  final TextEditingController controller;
  final String? label;
  final IconData? icon;
  final bool? disable;
  final Function(String?)? onChanged;
  final Function(String) onSaved;
  final List<FieldValidator> validate;

  @override
  State<InputText> createState() => _InputTextState();
}

class _InputTextState extends State<InputText> {
  final FocusNode _onFocus = FocusNode();

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
    return TextFormField(
      textAlignVertical: TextAlignVertical.bottom,
      controller: widget.controller,
      keyboardType: TextInputType.text,
      focusNode: _onFocus,
      enabled: widget.disable != null ? !widget.disable! : true,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.singleLineFormatter
      ],
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: MultiValidator(widget.validate),
      style: const TextStyle(
        color: Colors.black,
      ),
      decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
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
      onSaved: (value) => widget.onSaved(value.toString()),
    );
  }
}
