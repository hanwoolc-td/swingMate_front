import 'package:swingmate/features/auth/domain/entities/verification_code_delivery.dart';
import 'package:swingmate/features/auth/domain/repositories/auth_repository.dart';

class MockAuthRepository implements AuthRepository {
  static const testVerificationCode = '123456';

  final _verificationCodes = <String, String>{};
  final _verificationExpirations = <String, DateTime>{};

  @override
  Future<VerificationCodeDelivery> sendVerificationCode(
    String phoneNumber,
  ) async {
    _verificationCodes[phoneNumber] = testVerificationCode;
    _verificationExpirations[phoneNumber] = DateTime.now().add(
      const Duration(minutes: 3),
    );
    return const VerificationCodeDelivery(testCode: testVerificationCode);
  }

  @override
  Future<bool> verifyVerificationCode({
    required String phoneNumber,
    required String verificationCode,
  }) async {
    final expiration = _verificationExpirations[phoneNumber];
    if (expiration == null || !DateTime.now().isBefore(expiration)) {
      return false;
    }

    return _verificationCodes[phoneNumber] == verificationCode;
  }
}
