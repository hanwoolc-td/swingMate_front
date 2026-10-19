import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:swingmate/features/auth/domain/entities/auth_exception.dart';
import 'package:swingmate/features/auth/domain/entities/social_provider.dart';
import 'package:swingmate/features/auth/domain/repositories/social_credential_source.dart';

/// 카카오 SDK로 로그인하고 서버에 보낼 Access Token을 돌려준다.
/// Google 로그인은 아직 연동하지 않아 실패로 처리한다.
class SdkSocialCredentialSource implements SocialCredentialSource {
  const SdkSocialCredentialSource();

  @override
  Future<String> fetchToken(SocialProvider provider) async {
    return switch (provider) {
      SocialProvider.kakao => _kakaoAccessToken(),
      SocialProvider.google => throw const AuthException(
        AuthFailureReason.socialProviderUnavailable,
      ),
    };
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
