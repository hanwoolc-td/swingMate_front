import 'package:swingmate/features/auth/domain/entities/verification_code_delivery.dart';

abstract interface class AuthRepository {
  Future<VerificationCodeDelivery> sendVerificationCode(String phoneNumber);

  Future<bool> verifyVerificationCode({
    required String phoneNumber,
    required String verificationCode,
  });
}
