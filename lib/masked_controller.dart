library masked_controller;

import 'package:flutter/material.dart';
import 'package:masked_controller/mask.dart';

class MaskedTextController extends TextEditingController {
  Mask mask;
  String _previewsText = '';
  
  MaskedTextController() {
    addListener(_listener);
  }

  void _listener() {
    if (mask == null) return;

    final String currentText = text ?? '';
    final String maskedText = mask.applyMaskTo(string: mask.removeMaskFrom(string: currentText));

    if (maskedText == null) {
      print('is null, current text $currentText');
      value = value.copyWith(text: _previewsText, selection: TextSelection.fromPosition(TextPosition(offset: _previewsText.length)));
    } else {
      if (_previewsText == maskedText) {
        value = value.copyWith(text: maskedText, selection: TextSelection.fromPosition(TextPosition(offset: value.selection.end)));
        return;
      }

      final int cursorPosition = (_previewsText.length - currentText.length) + selection.end;
      _previewsText = maskedText;
      value = value.copyWith(text: maskedText, selection: TextSelection.fromPosition(TextPosition(offset: cursorPosition)));
    }
  }

  @override
  void dispose() {
    removeListener(_listener);
    super.dispose();
  }
}
