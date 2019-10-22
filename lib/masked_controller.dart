library masked_controller;

import 'package:flutter/material.dart';
import 'package:masked_controller/mask.dart';
import 'package:meta/meta.dart';

class MaskedController extends TextEditingController {
  MaskedController({@required Mask mask}) {
    assert(mask != null);

    _mask = mask;
    addListener(_listener);
  }

  Mask _mask;
  String _previewsText = '';

  String get unmaskedText => _mask.removeMaskFrom(string: _previewsText) ?? '';

  Mask get mask => _mask;

  set mask(Mask mask) {
    assert(mask != null);

    _mask = mask;
    update(text: text);
  }

  @override
  set text(String newText) {
    if (super.text != newText) {
      int cursorPosition;

      if (selection.baseOffset >= super.text.length) {
        cursorPosition = (newText ?? '').length;
      } else {
        cursorPosition = selection.baseOffset;
      }

      final TextSelection textSelection =
          TextSelection.collapsed(offset: cursorPosition);

      value = value.copyWith(
          text: newText, selection: textSelection, composing: TextRange.empty);
    }
  }

  void _listener() {
    if (mask == null) return;

    final String currentText = text ?? '';
    final String maskedText =
        mask.applyMaskTo(string: mask.removeMaskFrom(string: currentText));

    if (maskedText == null) {
      update(text: _previewsText);
      _moveCursorToEnd();
      return;
    }

    update(text: maskedText ?? '');
  }

  void _moveCursorToEnd() {
    final String text = this.text ?? '';
    _moveCursorTo(position: text.length);
  }

  void _moveCursorTo({@required int position}) {
    final TextPosition textPosition = TextPosition(offset: position);
    final TextSelection textSelection =
        TextSelection.fromPosition(textPosition);
    value = value.copyWith(text: text, selection: textSelection);
  }

  void update({@required String text}) {
    if (mask == null) return;

    if (text != null) {
      this.text = mask.applyMaskTo(string: mask.removeMaskFrom(string: text));
    } else {
      this.text = _previewsText;
    }

    _previewsText = text;
  }

  @override
  void dispose() {
    removeListener(_listener);
    super.dispose();
  }
}
