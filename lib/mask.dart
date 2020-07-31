import 'package:meta/meta.dart';

abstract class BaseMask {
  String applyMaskTo({@required String string});
  String removeMaskFrom({@required String string});
}

class Mask extends BaseMask {
  Mask({@required this.mask});

  final String mask;
  final String _letterSymbol = 'A';
  final String _numberSymbol = 'N';
  final String _alphanumericSymbol = 'X';
  final RegExp _onlyLetterRegex = RegExp(r'[a-zA-Z]');
  final RegExp _onlyNumbersRegex = RegExp(r'[0-9]');

  bool _isValidLetter({@required String character}) {
    if (character == null) return null;

    return character.contains(_onlyLetterRegex);
  }

  bool _isValidNumber({@required String character}) {
    if (character == null) return null;
    try {
      return character.contains(_onlyNumbersRegex);
    } on FormatException catch (_) {
      return false;
    }
  }

  bool _isValidAlphanumeric({@required String character}) {
    return _isValidLetter(character: character) ||
        _isValidNumber(character: character);
  }

  @override
  String applyMaskTo({String string}) {
    if (string == null) return null;

    if (string.length > mask.length) return null;

    String formatedValue = "";
    int maskIndex = 0;

    try {
      for (int count = 0; count < string.length; count++) {
        if (maskIndex >= mask.length) return null;

        final String character = string[count];
        String maskSymbol = mask[maskIndex];

        if (character == maskSymbol) {
          formatedValue += character;
        } else {
          while (maskSymbol != _letterSymbol &&
              maskSymbol != _numberSymbol &&
              maskSymbol != _alphanumericSymbol) {
            formatedValue += maskSymbol;
            maskSymbol = mask[++maskIndex];
          }

          final isValidLetter = maskSymbol == _letterSymbol &&
              _isValidLetter(character: character);
          final isValidNumber = maskSymbol == _numberSymbol &&
              _isValidNumber(character: character);
          final isValidAlphanumeric = maskSymbol == _alphanumericSymbol &&
              _isValidAlphanumeric(character: character);

          if (!isValidLetter && !isValidNumber && !isValidAlphanumeric)
            return null;

          formatedValue += character;
        }

        ++maskIndex;
      }
    } on Exception catch (_) {
      return null;
    }

    return formatedValue;
  }

  @override
  String removeMaskFrom({String string}) {
    if (string == null) return null;

    String clearText = "";
    for (int count = 0; count < string.length; count++) {
      final String character = string[count];
      if (_isValidNumber(character: character) ||
          _isValidLetter(character: character)) {
        clearText += character;
      }
    }
    return clearText;
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Mask && runtimeType == other.runtimeType && mask == other.mask;
  }

  @override
  int get hashCode => mask.hashCode;
}
