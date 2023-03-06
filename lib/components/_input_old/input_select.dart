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
    int textLength = 40 - _getLabelText().length;

    return Stack(
      children: [
        // Padding(
        //   padding: const EdgeInsets.only(top: 6),
        //   child: Row(
        //     children: [
        //       Text(
        //         _getLabelText(),
        //         style: const TextStyle(
        //             fontSize: 14, fontWeight: FontWeight.normal),
        //       ),
        //       const Text(
        //         ' *',
        //         style: TextStyle(
        //             fontSize: 14,
        //             color: Colors.red,
        //             fontWeight: FontWeight.normal),
        //       ),
        //     ],
        //   ),
        // ),
        DropdownButtonFormField<String>(
          value: widget.value ?? widget.items.first.value,
          icon: widget.icon != null
              ? Icon(widget.icon)
              : const Icon(Icons.keyboard_arrow_down),
          isExpanded: false,
          elevation: 4,
          menuMaxHeight: MediaQuery.of(context).size.height * 0.4,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            floatingLabelAlignment: FloatingLabelAlignment.center,
              prefixText: _getLabelText(),
              prefixStyle: const TextStyle(color: Colors.black, fontSize: 14)),
          onChanged: (String? value) => widget.onChanged(value.toString()),
          onSaved: (String? value) => widget.onChanged(value.toString()),
          items:
              widget.items.map<DropdownMenuItem<String>>((SelectOption item) {
            return DropdownMenuItem<String>(
              value: item.value,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  item.text.length > textLength
                      ? '${item.text.substring(0, textLength)}...'
                      : item.text,
                ),
              ),
            );
          }).toList(),
        )
      ],
    );
  }
}
