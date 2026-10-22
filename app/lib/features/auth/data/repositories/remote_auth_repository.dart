import 'package:swingmate/core/network/auth_session.dart';
import 'package:swingmate/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:swingmate/features/auth/domain/entities/auth_exception.dart';
import 'package:swingmate/features/auth/domain/entities/golf_experience.dart';
import 'package:swingmate/features/auth/domain/entities/lesson_interest.dart';
import 'package:swingmate/features/auth/domain/entities/member_registration.dart';
import 'package:swingmate/features/auth/domain/entities/pro_registration.dart';
import 'package:swingmate/features/auth/domain/entities/signup_result.dart';
import 'package:swingmate/features/auth/domain/entities/social_provider.dart';
import 'package:swingmate/features/auth/domain/entities/social_sign_in_result.dart';
import 'package:swingmate/features/auth/domain/entities/verification_code_delivery.dart';
import 'package:swingmate/features/auth/domain/repositories/auth_repository.dart';

class RemoteAuthRepository implements AuthRepository {
  RemoteAuthRepository(this._dataSource, this._session);

  final AuthRemoteDataSource _dataSource;
  final AuthSession _session;

  // 인증 요청 ID와 인증 성공 증명은 가입이 끝날 때까지 이 가입 시도 안에서만 쓴다.
  String? _verificationId;
  String? _verificationPhoneNumber;
  String? _verificationToken;

  @override
  Future<SocialSignInResult> signInWithSocial({
    required SocialProvider provider,
    required String token,
    String? accountEmail,
  }) async {
    _clearVerification();
    final model = await _dataSource.socialLogin(
      provider: switch (provider) {
        SocialProvider.kakao => 'KAKAO',
        SocialProvider.google => 'GOOGLE',
      },
      token: token,
    );
    _session.setSocialIdentity(provider: provider.name, email: accountEmail);

    if (model.isOnboardingCompleted) {
      _session.signIn(
        access: model.accessToken ?? '',
        refresh: model.refreshToken ?? '',
      );
    } else {
      _session.startOnboarding(model.onboardingToken ?? '');
    }
    return SocialSignInResult(
      isNewUser: model.isNewUser,
      isOnboardingCompleted: model.isOnboardingCompleted,
    );
  }

  @override
  Future<VerificationCodeDelivery> sendVerificationCode(
    String phoneNumber,
  ) async {
    // 같은 번호로 다시 보낼 때만 이전 요청을 넘겨 재발송으로 처리한다.
    final previousId = _verificationPhoneNumber == phoneNumber
        ? _verificationId
        : null;
    final model = await _dataSource.sendVerification(
      phoneNumber: phoneNumber,
      previousVerificationId: previousId,
    );
    _verificationId = model.verificationId;
    _verificationPhoneNumber = phoneNumber;
    _verificationToken = null;
    return const VerificationCodeDelivery();
  }

  @override
  Future<bool> verifyVerificationCode({
    required String phoneNumber,
    required String verificationCode,
  }) async {
    final verificationId = _verificationId;
    if (verificationId == null || _verificationPhoneNumber != phoneNumber) {
      throw const AuthException(AuthFailureReason.verificationExpired);
    }

    try {
      final model = await _dataSource.confirmVerification(
        verificationId: verificationId,
        code: verificationCode,
      );
      _verificationToken = model.verificationToken;
      return true;
    } on AuthException catch (error) {
      if (error.reason == AuthFailureReason.verificationCodeInvalid) {
        return false;
      }
      rethrow;
    }
  }

  @override
  Future<SignupResult> completeMemberSignup(
    MemberRegistration registration,
  ) async {
    final result = await _dataSource.completeMember({
      'verificationToken': _requireVerificationToken(),
      'name': registration.name,
      'phoneNumber': registration.phoneNumber,
      'lessonInterests': [
        for (final interest in registration.lessonInterests)
          _interestCodes[interest],
      ],
      'golfExperience': _experienceCodes[registration.golfExperience],
    });
    return _finishSignup(result.accessToken, result.refreshToken, null);
  }

  @override
  Future<SignupResult> completeProSignup(ProRegistration registration) async {
    final result = await _dataSource.completePro({
      'verificationToken': _requireVerificationToken(),
      'name': registration.name,
      'phoneNumber': registration.phoneNumber,
      'introduction': registration.introduction,
      'careers': registration.careers,
      'availability': [
        for (final day in registration.availability)
          {
            'dayOfWeek': day.weekday.name.toUpperCase(),
            'timeRanges': [
              for (final range in day.timeRanges)
                {
                  'startTime': _formatMinutes(range.startMinutes),
                  'endTime': _formatMinutes(range.endMinutes),
                },
            ],
          },
      ],
    });
    return _finishSignup(
      result.accessToken,
      result.refreshToken,
      result.proCode,
    );
  }

  SignupResult _finishSignup(String access, String refresh, String? proCode) {
    _session.signIn(access: access, refresh: refresh);
    _clearVerification();
    return SignupResult(proCode: proCode);
  }

  String _requireVerificationToken() {
    return _verificationToken ??
        (throw const AuthException(AuthFailureReason.verificationExpired));
  }

  void _clearVerification() {
    _verificationId = null;
    _verificationPhoneNumber = null;
    _verificationToken = null;
  }

  static String _formatMinutes(int minutes) {
    final hour = (minutes ~/ 60).toString().padLeft(2, '0');
    final minute = (minutes % 60).toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  static const _interestCodes = {
    LessonInterest.beginner: 'BEGINNER',
    LessonInterest.swingCorrection: 'SWING_CORRECTION',
    LessonInterest.shortGame: 'SHORT_GAME',
    LessonInterest.driver: 'DRIVER',
    LessonInterest.iron: 'IRON',
    LessonInterest.putting: 'PUTTING',
    LessonInterest.lobShot: 'LOB_SHOT',
    LessonInterest.stingerShot: 'STINGER_SHOT',
    LessonInterest.other: 'OTHER',
  };

  static const _experienceCodes = {
    GolfExperience.under6Months: 'UNDER_6_MONTHS',
    GolfExperience.months6To3Years: 'MONTHS_6_TO_3_YEARS',
    GolfExperience.years3To7: 'YEARS_3_TO_7',
    GolfExperience.over7Years: 'OVER_7_YEARS',
  };
}
