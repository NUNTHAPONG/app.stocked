import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

class SelectOption {
  late String value;
  late String text;

  SelectOption(this.value, this.text);
}

class InputSelect extends StatefulWidget {
  const InputSelect({
    super.key,
    this.value,
    this.label,
    this.icon,
    this.disable,
    required this.items,
    required this.onChanged,
    required this.validate,
  });

  final String? value;
  final String? label;
  final IconData? icon;
  final bool? disable;
  final List<SelectOption> items;
  final Function(String) onChanged;
  final List<FieldValidator> validate;

  @override
  State<InputSelect> createState() => _InputSelectState();
}

class _InputSelectState extends State<InputSelect> {
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
        DropdownButtonFormField<String>(
          value: widget.value ?? widget.items.first.value,
          icon: widget.icon != null
              ? Icon(widget.icon)
              : const Icon(Icons.keyboard_arrow_down),
          isExpanded: true,
          elevation: 4,
          menuMaxHeight: MediaQuery.of(context).size.height * 0.25,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: MultiValidator(widget.validate),
          style: const TextStyle(color: Colors.black),
          // underline: Container(
          //   height: 2,
          //   color: Colors.deepPurpleAccent,
          // ),
          onChanged: (String? value) => widget.onChanged(value.toString()),
          items: widget.items.map<DropdownMenuItem<String>>((SelectOption item) {
            return DropdownMenuItem<String>(
              alignment: AlignmentDirectional.centerEnd,
              value: item.value,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  item.text,
                  textAlign: TextAlign.start,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
