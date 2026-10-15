import 'package:dio/dio.dart';
import 'package:swingmate/features/auth/data/models/auth_models.dart';
import 'package:swingmate/features/auth/domain/entities/auth_exception.dart';

class AuthRemoteDataSource {
  const AuthRemoteDataSource(this._dio);

  static const _signupPurpose = 'SIGNUP_PHONE_VERIFICATION';

  final Dio _dio;

  Future<SocialLoginModel> socialLogin({
    required String provider,
    required String token,
  }) async {
    final json = await _request(
      () => _dio.post<Map<String, dynamic>>(
        '/api/v1/auth/social/login',
        data: {'provider': provider, 'idToken': token},
      ),
    );
    return SocialLoginModel.fromJson(json);
  }

  Future<PhoneVerificationModel> sendVerification({
    required String phoneNumber,
    String? previousVerificationId,
  }) async {
    final json = await _request(
      () => _dio.post<Map<String, dynamic>>(
        '/api/v1/phone-verifications',
        data: {
          'phoneNumber': phoneNumber,
          'purpose': _signupPurpose,
          'previousVerificationId': ?previousVerificationId,
        },
      ),
    );
    return PhoneVerificationModel.fromJson(json);
  }

  Future<PhoneConfirmationModel> confirmVerification({
    required String verificationId,
    required String code,
  }) async {
    final json = await _request(
      () => _dio.post<Map<String, dynamic>>(
        '/api/v1/phone-verifications/$verificationId/confirm',
        data: {'code': code},
      ),
    );
    return PhoneConfirmationModel.fromJson(json);
  }

  Future<OnboardingResultModel> completeMember(Map<String, dynamic> body) =>
      _complete('/api/v1/onboarding/member', body);

  Future<OnboardingResultModel> completePro(Map<String, dynamic> body) =>
      _complete('/api/v1/onboarding/pro', body);

  Future<OnboardingResultModel> _complete(
    String path,
    Map<String, dynamic> body,
  ) async {
    final json = await _request(
      () => _dio.put<Map<String, dynamic>>(path, data: body),
    );
    return OnboardingResultModel.fromJson(json);
  }

  /// 서버 오류 코드(`code`)를 [AuthException]으로 바꿔 Dio 예외가 위로 새지 않게 한다.
  Future<Map<String, dynamic>> _request(
    Future<Response<Map<String, dynamic>>> Function() send,
  ) async {
    try {
      final response = await send();
      return response.data ?? const {};
    } on DioException catch (error) {
      throw AuthException(_reasonOf(error));
    } on TypeError {
      throw const AuthException(AuthFailureReason.unknown);
    }
  }

  AuthFailureReason _reasonOf(DioException error) {
    final response = error.response;
    if (response == null) return AuthFailureReason.network;

    final data = response.data;
    final code = data is Map<String, dynamic> ? data['code'] : null;
    return switch (code) {
      'SOCIAL_TOKEN_INVALID' => AuthFailureReason.invalidSocialToken,
      'SOCIAL_PROVIDER_UNAVAILABLE' =>
        AuthFailureReason.socialProviderUnavailable,
      'PHONE_ALREADY_IN_USE' => AuthFailureReason.phoneAlreadyInUse,
      'VERIFICATION_CODE_INVALID' => AuthFailureReason.verificationCodeInvalid,
      'VERIFICATION_EXPIRED' => AuthFailureReason.verificationExpired,
      'VERIFICATION_ATTEMPTS_EXCEEDED' =>
        AuthFailureReason.verificationAttemptsExceeded,
      'SMS_SEND_LIMIT_EXCEEDED' => AuthFailureReason.sendLimitExceeded,
      'INVALID_REQUEST' ||
      'PHONE_NUMBER_INVALID' ||
      'NAME_INVALID' ||
      'LESSON_INTEREST_REQUIRED' ||
      'GOLF_EXPERIENCE_REQUIRED' ||
      'PRO_INTRODUCTION_REQUIRED' ||
      'PRO_CAREER_REQUIRED' ||
      'AVAILABILITY_INVALID' => AuthFailureReason.invalidInput,
      _ => AuthFailureReason.unknown,
    };
  }
}
