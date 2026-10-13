String formatKoreanPhoneNumber(String phoneNumber) {
  final digits = phoneNumber.replaceAll(RegExp(r'\D'), '');

  return switch (digits.length) {
    11 =>
      '${digits.substring(0, 3)}-${digits.substring(3, 7)}-${digits.substring(7)}',
    10 =>
      '${digits.substring(0, 3)}-${digits.substring(3, 6)}-${digits.substring(6)}',
    _ => phoneNumber,
  };
}
