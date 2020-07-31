import 'package:flutter_test/flutter_test.dart';
import 'package:masked_controller/mask.dart';

void main() {
  test('masks are equals', () {
    final mask1 = Mask(mask: 'AA.AA');
    final mask2 = Mask(mask: 'AA.AA');
    final mask3 = Mask(mask: 'NN');

    expect(mask1 == mask2, true);
    expect(mask1 != mask3, true);
    expect(mask2 != mask3, true);
  });

  test('test mask for numbers', () {
    final String cellPhoneMask = '(NN) N NNNN-NNNN';
    final Mask mask = Mask(mask: cellPhoneMask);
    expect(mask.applyMaskTo(string: '79'), '(79');
    expect(mask.applyMaskTo(string: '799'), '(79) 9');
    expect(mask.applyMaskTo(string: '7999'), '(79) 9 9');
    expect(mask.applyMaskTo(string: '79999'), '(79) 9 99');
    expect(mask.applyMaskTo(string: '799999'), '(79) 9 999');
    expect(mask.applyMaskTo(string: '7999999'), '(79) 9 9999');
    expect(mask.applyMaskTo(string: '79999999'), '(79) 9 9999-9');
    expect(mask.applyMaskTo(string: '799999999'), '(79) 9 9999-99');
    expect(mask.applyMaskTo(string: '7999999999'), '(79) 9 9999-999');
    expect(mask.applyMaskTo(string: '79999999999'), '(79) 9 9999-9999');
    expect(mask.applyMaskTo(string: '(79) 9 9999-999'), '(79) 9 9999-999');
  });

  test('cpf test', () {
    final Mask mask = Mask(mask: 'NNN.NNN.NNN-NN');
    expect(mask.applyMaskTo(string: '00000000000'), '000.000.000-00');
  });

  test('test letters and numbers', () {
    final mask = Mask(mask: 'AA.NN');
    expect(mask.applyMaskTo(string: '11.aa'), null);
    expect(mask.applyMaskTo(string: 'aa.1a'), null);
    expect(mask.applyMaskTo(string: 'aa11'), 'aa.11');
    expect(mask.applyMaskTo(string: 'aaaaa'), null);
  });

  test('test alphanumeric', () {
    final mask = Mask(mask: 'XXX-XXX');
    expect(mask.applyMaskTo(string: 'a'), 'a');
    expect(mask.applyMaskTo(string: 'ab'), 'ab');
    expect(mask.applyMaskTo(string: 'abc'), 'abc');
    expect(mask.applyMaskTo(string: 'abc1'), 'abc-1');
    expect(mask.applyMaskTo(string: 'abc12'), 'abc-12');
    expect(mask.applyMaskTo(string: 'abc123'), 'abc-123');
    expect(mask.applyMaskTo(string: '123456'), '123-456');
    expect(mask.applyMaskTo(string: 'abcabc'), 'abc-abc');
  });

  test('test alphanumeric only for max length', () {
    final mask = Mask(mask: 'XXXXXX');
    expect(mask.applyMaskTo(string: 'abc123'), 'abc123');
    expect(mask.applyMaskTo(string: 'Aa12'), 'Aa12');
  });

  test('test remove mask', () {
    final Mask mask = Mask(mask: 'NNN.AAA.NNN');
    final Mask mask2 = Mask(mask: 'AAA');
    final Mask mask3 = Mask(mask: 'NNN');
    final Mask mask4 = Mask(mask: 'N!N!N');
    final Mask mask5 = Mask(mask: 'XX.XX');
    final Mask mask6 = Mask(mask: 'XXX');

    final String maskedString = '555.aaa.111';
    final String maskedString2 = 'abc';
    final String maskedString3 = '123';
    final String maskedString4 = '1!1!1';
    final String maskedString5 = 'ab.4D';
    final String maskedString6 = 'A12';

    expect(mask.removeMaskFrom(string: maskedString), '555aaa111');
    expect(mask2.removeMaskFrom(string: maskedString2), 'abc');
    expect(mask3.removeMaskFrom(string: maskedString3), '123');
    expect(mask4.removeMaskFrom(string: maskedString4), '111');
    expect(mask5.removeMaskFrom(string: maskedString5), 'ab4D');
    expect(mask6.removeMaskFrom(string: maskedString6), 'A12');
  });
}
