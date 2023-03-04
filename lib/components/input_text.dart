import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';

class InputText extends StatefulWidget {
  InputText(
      {super.key,
      required this.controller,
      this.label,
      this.icon,
      this.disable,
      this.onChanged,
      required this.onSaved,
      required this.validate});

  TextEditingController controller;
  String? label;
  IconData? icon;
  bool? disable;
  Function(String?)? onChanged;
  Function(String) onSaved;
  List<FieldValidator> validate;

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
          keyboardType: TextInputType.text,
          focusNode: _onFocus,
          enabled: widget.disable != null ? !widget.disable! : true,
          textAlign: TextAlign.right,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.singleLineFormatter
          ],
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
            // prefixText: widget.label,
            // prefixStyle: const TextStyle(
            //   fontSize: 14,
            // ),
            // border: OutlineInputBorder(
            //   borderRadius: BorderRadius.circular(10.0),
            // ),
            // focusedBorder: OutlineInputBorder(
            //   borderSide: const BorderSide(color: Colors.blue, width: 1),
            //   borderRadius: BorderRadius.circular(10.0),
            // ),
            fillColor: Colors.grey,
            // hintText: widget.label,
            // hintStyle: const TextStyle(
            //   color: Colors.grey,
            //   fontSize: 16,
            //   fontWeight: FontWeight.w400,
            // ),
            // floatingLabelBehavior: FloatingLabelBehavior.never,
            // labelText: widget.label,
            // labelStyle: const TextStyle(
            //   fontSize: 14,
            // ),
          ),
          onChanged: widget.onChanged != null ? widget.onChanged! : null,
          onSaved: (value) => widget.onSaved(value.toString()),
        ),
      ],
    );
  }
}
