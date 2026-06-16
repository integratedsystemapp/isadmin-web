import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  String _format(String digits) {
    if (digits.isEmpty) return '';
    // 앞자리 0 정리
    digits = digits.replaceFirst(RegExp(r'^0+(?=\d)'), '');
    final buf = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      final reverseIndex = digits.length - i; // 뒤에서부터 몇 번째 자리인지
      buf.write(digits[i]);
      if (reverseIndex > 1 && reverseIndex % 3 == 1) {
        buf.write(','); // 3자리마다 콤마
      }
    }
    return buf.toString();
  }

  bool _isDigit(String ch) => ch.codeUnitAt(0) ^ 0x30 <= 9 && ch.codeUnitAt(0) ^ 0x30 >= 0;

  int _countDigits(String s) {
    var cnt = 0;
    for (final ch in s.characters) {
      if (ch.length == 1 && _isDigit(ch)) cnt++;
    }
    return cnt;
  }

  // formatted 문자열에서 "오른쪽에 digitsRight 개의 숫자"가 남도록 커서 위치를 계산
  int _caretIndexKeepingDigitsFromRight(String formatted, int digitsRight) {
    var digitsSeen = 0;
    for (int i = formatted.length; i >= 0; i--) {
      // i는 "문자 사이" 인덱스 (0..length)
      final leftIdx = i - 1;
      if (leftIdx >= 0) {
        final ch = formatted[leftIdx];
        if (_isDigit(ch)) {
          if (digitsSeen == digitsRight) return i;
          digitsSeen++;
        }
      }
    }
    return 0;
  }

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final oldText = oldValue.text;
    final newText = newValue.text;

    // 새 입력에서 숫자만 추출
    final newDigits = newText.replaceAll(RegExp(r'[^0-9]'), '');
    final oldDigits = oldText.replaceAll(RegExp(r'[^0-9]'), '');

    // 변경 없음 → 그대로
    if (newDigits == oldDigits) {
      return newValue;
    }

    // 포맷팅
    final formatted = _format(newDigits);

    // 커서: 기존 커서 기준으로 "오른쪽에 남은 숫자 개수"를 유지
    final selectionDigitsToRight = oldDigits.length - _countDigits(oldText.substring(0, oldValue.selection.end));
    final caret = _caretIndexKeepingDigitsFromRight(formatted, selectionDigitsToRight.clamp(0, newDigits.length));

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: caret),
      composing: TextRange.empty,
    );
  }
}
