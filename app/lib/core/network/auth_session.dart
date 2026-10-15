import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 로그인 중 받은 토큰을 메모리에 보관한다. 앱을 다시 켜면 사라진다.
// ponytail: 보안 저장소(flutter_secure_storage) 없이 메모리에만 둔다. 자동 로그인이 필요할 때 교체.
class AuthSession {
  String? onboardingToken;
  String? accessToken;
  String? refreshToken;

  /// 가입 완료 사용자는 액세스 토큰, 가입 중인 사용자는 온보딩 토큰을 쓴다.
  String? get bearerToken => accessToken ?? onboardingToken;

  void startOnboarding(String token) {
    onboardingToken = token;
    accessToken = null;
    refreshToken = null;
  }

  void signIn({required String access, required String refresh}) {
    accessToken = access;
    refreshToken = refresh;
    onboardingToken = null;
  }
}

final authSessionProvider = Provider<AuthSession>((ref) => AuthSession());
