import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

class DecimalTextInputFormatter extends TextInputFormatter {
  DecimalTextInputFormatter({int? digits}) : _digits = digits ?? 2;
  final int _digits;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue, // unused.
    TextEditingValue newValue,
  ) {
    TextSelection newSelection = newValue.selection;
    String truncated = newValue.text;

    String value = newValue.text;

    if (value.contains(".") &&
        value.substring(value.indexOf(".") + 1).length > _digits) {
      truncated = oldValue.text;
      newSelection = oldValue.selection;
    } else if (value == "." && _digits > 0) {
      truncated = "0.";

      newSelection = newValue.selection.copyWith(
        baseOffset: min(truncated.length, truncated.length + 1),
        extentOffset: min(truncated.length, truncated.length + 1),
      );
    } else if (_digits == 0) {
      truncated = newValue.text.replaceAll(RegExp(r'[\.](.+)*'), '');
      newSelection = newValue.selection.copyWith(
        baseOffset: min(truncated.length, truncated.length + 1),
        extentOffset: min(truncated.length, truncated.length + 1),
      );
    }

    return TextEditingValue(
      text: truncated,
      selection: newSelection,
      composing: TextRange.empty,
    );
  }
}
