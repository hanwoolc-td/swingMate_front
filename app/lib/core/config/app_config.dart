import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AppEnvironment { development, production }

class AppConfig {
  const AppConfig({
    required this.environment,
    required this.apiBaseUrl,
    this.kakaoNativeAppKey = defaultKakaoNativeAppKey,
    this.googleServerClientId = defaultGoogleServerClientId,
    this.useDevSocialLogin = false,
  });

  /// 카카오 개발자 콘솔의 네이티브 앱 키. 앱 안에 들어가는 공개 값이다.
  /// Android 매니페스트와 iOS Info.plist의 `kakao<키>` URL 스킴도 같은 키를 쓴다.
  /// Google Cloud 콘솔의 웹 클라이언트 ID. 앱이 서버용 ID 토큰을 받을 때 쓰는 공개 값이다.
  /// iOS 클라이언트 ID는 `Info.plist`의 `GIDClientID`에 있다.
  static const defaultGoogleServerClientId =
      '32094329428-h878ssdsglmq287mqgsd2hg27o29d4ci.apps.googleusercontent.com';

  static const defaultKakaoNativeAppKey = '80bf73518a4fbbc2e085b62c6bd3726e';

  factory AppConfig.fromEnvironment() {
    const environmentName = String.fromEnvironment(
      'APP_ENV',
      defaultValue: 'development',
    );
    const apiBaseUrl = String.fromEnvironment(
      'API_BASE_URL',
      defaultValue: 'http://localhost:8080',
    );

    const useDevSocialLogin = bool.fromEnvironment('DEV_SOCIAL_LOGIN');
    const kakaoNativeAppKey = String.fromEnvironment(
      'KAKAO_NATIVE_APP_KEY',
      defaultValue: defaultKakaoNativeAppKey,
    );

    const googleServerClientId = String.fromEnvironment(
      'GOOGLE_SERVER_CLIENT_ID',
      defaultValue: defaultGoogleServerClientId,
    );

    return AppConfig(
      kakaoNativeAppKey: kakaoNativeAppKey,
      googleServerClientId: googleServerClientId,
      useDevSocialLogin: useDevSocialLogin,
      environment: switch (environmentName) {
        'production' => AppEnvironment.production,
        _ => AppEnvironment.development,
      },
      apiBaseUrl: apiBaseUrl,
    );
  }

  final AppEnvironment environment;
  final String apiBaseUrl;
  final String kakaoNativeAppKey;
  final String googleServerClientId;

  /// `--dart-define=DEV_SOCIAL_LOGIN=true`: 카카오·Google 대신 임의 토큰으로 로그인한다.
  /// 서버를 `OAUTH_MOCK_ENABLED=true`로 켰을 때만 동작하며 운영 환경에서는 무시한다.
  final bool useDevSocialLogin;

  bool get isProduction => environment == AppEnvironment.production;

  String get environmentLabel => switch (environment) {
    AppEnvironment.development => '개발',
    AppEnvironment.production => '운영',
  };
}

final appConfigProvider = Provider<AppConfig>((ref) {
  return AppConfig.fromEnvironment();
});
