import 'package:flutter_test/flutter_test.dart';
import 'package:swingmate/features/auth/presentation/helpers/phone_number_formatter.dart';

void main() {
  group('formatKoreanPhoneNumber', () {
    test('formats an 11-digit mobile number', () {
      expect(formatKoreanPhoneNumber('01012345678'), '010-1234-5678');
    });

    test('keeps unsupported input unchanged', () {
      expect(formatKoreanPhoneNumber('01012'), '01012');
    });
  });
}
