enum AuthFailureReason {
  invalidSocialToken,
  socialProviderUnavailable,
  phoneAlreadyInUse,
  verificationCodeInvalid,
  verificationExpired,
  verificationAttemptsExceeded,
  sendLimitExceeded,
  invalidInput,
  network,
  unknown,
}

/// 네트워크·서버 오류를 Domain이 이해하는 사유로 바꾼 예외.
class AuthException implements Exception {
  const AuthException(this.reason);

  final AuthFailureReason reason;

  @override
  String toString() => 'AuthException($reason)';
}
