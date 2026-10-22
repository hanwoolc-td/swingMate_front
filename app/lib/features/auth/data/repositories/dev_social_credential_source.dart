import 'package:swingmate/features/auth/domain/entities/social_provider.dart';
import 'package:swingmate/features/auth/domain/entities/social_credential.dart';
import 'package:swingmate/features/auth/domain/repositories/social_credential_source.dart';

/// 개발용: 카카오·Google SDK 없이 임의의 토큰 문자열을 만든다.
/// 서버를 `OAUTH_MOCK_ENABLED=true`로 켰을 때만 로그인된다.
/// 같은 `DEV_SOCIAL_ID`로 다시 실행하면 같은 계정으로 들어간다.
class DevSocialCredentialSource implements SocialCredentialSource {
  const DevSocialCredentialSource();

  static const _devId = String.fromEnvironment(
    'DEV_SOCIAL_ID',
    defaultValue: 'dev-user',
  );

  @override
  Future<SocialCredential> fetchCredential(SocialProvider provider) async {
    return SocialCredential(token: '${provider.name}-$_devId');
  }
}
