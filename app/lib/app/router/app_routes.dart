/// SwingMate에서 사용하는 경로와 라우트 이름을 관리한다.
///
/// 인증 기능이 추가되면 public/protected 경로 분류도 이 파일에서 관리한다.
abstract final class AppRoutes {
  static const loginPath = '/login';
  static const loginName = 'login';

  static const roleSelectionPath = '/onboarding/role';
  static const roleSelectionName = 'role-selection';

  static const proProfilePath = '/onboarding/pro-profile';
  static const proProfileName = 'pro-profile';

  static const proCareerPath = '/onboarding/pro-career';
  static const proCareerName = 'pro-career';

  static const proAvailabilityPath = '/onboarding/pro-availability';
  static const proAvailabilityName = 'pro-availability';

  static const memberProfilePath = '/onboarding/member-profile';
  static const memberProfileName = 'member-profile';

  static const phoneVerificationPath =
      '/onboarding/member-profile/verification';
  static const phoneVerificationName = 'phone-verification';

  static const lessonPreferencesPath =
      '/onboarding/member-profile/lesson-preferences';
  static const lessonPreferencesName = 'lesson-preferences';

  static const lessonInterestsPath =
      '/onboarding/member-profile/lesson-interests';
  static const lessonInterestsName = 'lesson-interests';

  static const proCodeConnectionPath =
      '/onboarding/member-profile/pro-code-connection';
  static const proCodeConnectionName = 'pro-code-connection';

  static const proConnectionSuccessPath =
      '/onboarding/member-profile/pro-connection-success';
  static const proConnectionSuccessName = 'pro-connection-success';

  static const proConnectionFailurePath =
      '/onboarding/member-profile/pro-connection-failure';
  static const proConnectionFailureName = 'pro-connection-failure';

  static const homePath = '/';
  static const homeName = 'home';

  static const morePath = '/more';
  static const moreName = 'more';

  static const accountSecurityPath = '/account-security';
  static const accountSecurityName = 'account-security';

  static const deviceSessionsPath = '/account-security/devices';
  static const deviceSessionsName = 'device-sessions';

  static const notificationsPath = '/notifications';
  static const notificationsName = 'notifications';

  static const setupPath = '/setup';
  static const setupName = 'setup';

  static bool isPublicRoute(String location) =>
      location == loginPath || location == roleSelectionPath;
}
