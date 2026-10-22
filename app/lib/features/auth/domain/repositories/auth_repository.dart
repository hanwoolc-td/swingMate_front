import 'package:swingmate/features/auth/domain/entities/member_registration.dart';
import 'package:swingmate/features/auth/domain/entities/pro_registration.dart';
import 'package:swingmate/features/auth/domain/entities/signup_result.dart';
import 'package:swingmate/features/auth/domain/entities/social_provider.dart';
import 'package:swingmate/features/auth/domain/entities/social_sign_in_result.dart';
import 'package:swingmate/features/auth/domain/entities/verification_code_delivery.dart';

/// 실패는 [AuthException]으로 전달한다.
abstract interface class AuthRepository {
  Future<SocialSignInResult> signInWithSocial({
    required SocialProvider provider,
    required String token,
    String? accountEmail,
  });

  Future<VerificationCodeDelivery> sendVerificationCode(String phoneNumber);

  /// 인증번호가 틀리면 `false`, 만료·횟수 초과 등은 예외로 알린다.
  Future<bool> verifyVerificationCode({
    required String phoneNumber,
    required String verificationCode,
  });

  Future<SignupResult> completeMemberSignup(MemberRegistration registration);

  Future<SignupResult> completeProSignup(ProRegistration registration);
}
