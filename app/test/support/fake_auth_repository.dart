import 'dart:async';

import 'package:swingmate/features/auth/domain/entities/member_registration.dart';
import 'package:swingmate/features/auth/domain/entities/pro_registration.dart';
import 'package:swingmate/features/auth/domain/entities/signup_result.dart';
import 'package:swingmate/features/auth/domain/entities/social_provider.dart';
import 'package:swingmate/features/auth/domain/entities/social_sign_in_result.dart';
import 'package:swingmate/features/auth/domain/entities/verification_code_delivery.dart';
import 'package:swingmate/features/auth/domain/repositories/auth_repository.dart';

/// 서버 없이 화면·ViewModel 테스트를 돌리기 위한 가짜 Repository.
/// `error`를 지정하면 모든 호출이 그 예외로 실패한다.
class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository({
    this.sendCompleter,
    this.signInResult = const SocialSignInResult(
      isNewUser: true,
      isOnboardingCompleted: false,
    ),
    this.error,
  });

  static const testVerificationCode = '123456';

  final Completer<VerificationCodeDelivery>? sendCompleter;
  final SocialSignInResult signInResult;
  Object? error;

  int sendCallCount = 0;
  SocialProvider? signedInProvider;
  String? signedInToken;
  MemberRegistration? memberRegistration;
  ProRegistration? proRegistration;

  @override
  Future<SocialSignInResult> signInWithSocial({
    required SocialProvider provider,
    required String token,
  }) async {
    _throwIfFailing();
    signedInProvider = provider;
    signedInToken = token;
    return signInResult;
  }

  @override
  Future<VerificationCodeDelivery> sendVerificationCode(String phoneNumber) {
    sendCallCount++;
    if (error != null) return Future.error(error!);
    return sendCompleter?.future ??
        Future.value(const VerificationCodeDelivery(testCode: '123456'));
  }

  @override
  Future<bool> verifyVerificationCode({
    required String phoneNumber,
    required String verificationCode,
  }) async {
    _throwIfFailing();
    return verificationCode == testVerificationCode;
  }

  @override
  Future<SignupResult> completeMemberSignup(
    MemberRegistration registration,
  ) async {
    _throwIfFailing();
    memberRegistration = registration;
    return const SignupResult();
  }

  @override
  Future<SignupResult> completeProSignup(ProRegistration registration) async {
    _throwIfFailing();
    proRegistration = registration;
    return const SignupResult(proCode: 'ABC123');
  }

  void _throwIfFailing() {
    final failure = error;
    if (failure != null) throw failure;
  }
}
