import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:swingmate/features/auth/domain/entities/auth_exception.dart';
import 'package:swingmate/features/auth/domain/entities/social_provider.dart';
import 'package:swingmate/features/auth/domain/repositories/social_credential_source.dart';

/// 카카오·Google SDK로 로그인하고 서버에 보낼 토큰을 돌려준다.
/// 카카오는 Access Token, Google은 ID Token이다.
class SdkSocialCredentialSource implements SocialCredentialSource {
  const SdkSocialCredentialSource();

  @override
  Future<String> fetchToken(SocialProvider provider) async {
    return switch (provider) {
      SocialProvider.kakao => _kakaoAccessToken(),
      SocialProvider.google => _googleIdToken(),
    };
  }

  Future<String> _googleIdToken() async {
    try {
      final account = await GoogleSignIn.instance.authenticate();
      final idToken = account.authentication.idToken;
      if (idToken == null) {
        debugPrint('Google 로그인 실패: ID 토큰이 비어 있음');
        throw const AuthException(AuthFailureReason.invalidSocialToken);
      }
      return idToken;
    } on GoogleSignInException catch (error) {
      debugPrint('Google 로그인 실패: ${error.code} ${error.description}');
      throw AuthException(switch (error.code) {
        GoogleSignInExceptionCode.canceled ||
        GoogleSignInExceptionCode.interrupted => AuthFailureReason.cancelled,
        _ => AuthFailureReason.invalidSocialToken,
      });
    }
  }

  Future<String> _kakaoAccessToken() async {
    try {
      return (await _loginWithKakaoTalkOrAccount()).accessToken;
    } on KakaoClientException catch (error) {
      throw AuthException(
        error.reason == ClientErrorCause.cancelled
            ? AuthFailureReason.cancelled
            : AuthFailureReason.invalidSocialToken,
      );
    } on KakaoException {
      throw const AuthException(AuthFailureReason.invalidSocialToken);
    }
  }

  /// 카카오톡이 설치돼 있으면 앱으로, 아니면 카카오 계정 웹 로그인으로 진행한다.
  /// 설치 여부를 먼저 확인하지 않으면 iOS에서는 설치 안내 웹페이지가 열린다.
  Future<OAuthToken> _loginWithKakaoTalkOrAccount() async {
    return await isKakaoTalkInstalled()
        ? UserApi.instance.loginWithKakaoTalk()
        : UserApi.instance.loginWithKakaoAccount();
  }
}
