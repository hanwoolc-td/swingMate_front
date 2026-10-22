import 'package:swingmate/features/auth/domain/entities/social_provider.dart';
import 'package:swingmate/features/auth/domain/entities/social_credential.dart';

/// 카카오·Google 로그인 후 서버에 보낼 토큰을 가져온다.
/// 카카오는 Access Token, Google은 ID Token이다.
abstract interface class SocialCredentialSource {
  Future<SocialCredential> fetchCredential(SocialProvider provider);
}
