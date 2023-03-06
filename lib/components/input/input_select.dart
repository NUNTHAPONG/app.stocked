import 'package:flutter/material.dart';

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
  });

  final String? value;
  final String? label;
  final IconData? icon;
  final bool? disable;
  final List<SelectOption> items;
  final Function(String) onChanged;

  @override
  State<InputSelect> createState() => _InputSelectState();
}

class _InputSelectState extends State<InputSelect> {
  String _getLabelText() {
    if (widget.label != null) {
      return widget.label!;
    } else {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {

    return DropdownButtonFormField<String>(
      value: widget.value ?? widget.items.first.value,
      icon: widget.icon != null
          ? Icon(widget.icon)
          : const Icon(Icons.keyboard_arrow_down),
      isExpanded: true,
      elevation: 4,
      menuMaxHeight: MediaQuery.of(context).size.height * 0.3,
      style: const TextStyle(color: Colors.black),
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
      onChanged: (String? value) => widget.onChanged(value.toString()),
      onSaved: (String? value) => widget.onChanged(value.toString()),
      items: widget.items.map<DropdownMenuItem<String>>((SelectOption item) {
        return DropdownMenuItem<String>(
          value: item.value,
          child: Text(
            item.text,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontSize: Theme.of(context).textTheme.labelMedium!.fontSize,
                fontFamily: 'AppFonts'),
          ),
        );
      }).toList(),
    );
  }
}
