import 'package:go_router/go_router.dart';
import 'package:swingmate/app/router/app_routes.dart';
import 'package:swingmate/features/auth/presentation/screens/login_screen.dart';
import 'package:swingmate/features/auth/presentation/screens/lesson_preferences_screen.dart';
import 'package:swingmate/features/auth/presentation/screens/member_profile_screen.dart';
import 'package:swingmate/features/auth/presentation/screens/phone_verification_screen.dart';
import 'package:swingmate/features/auth/presentation/screens/pro_code_connection_screen.dart';
import 'package:swingmate/features/auth/presentation/screens/pro_connection_success_screen.dart';
import 'package:swingmate/features/auth/presentation/screens/pro_connection_failure_screen.dart';
import 'package:swingmate/features/auth/presentation/screens/role_selection_screen.dart';
import 'package:swingmate/features/auth/presentation/screens/pro_profile_screen.dart';
import 'package:swingmate/features/auth/presentation/screens/pro_career_screen.dart';
import 'package:swingmate/features/auth/presentation/screens/pro_availability_screen.dart';
import 'package:swingmate/features/home/presentation/screens/home_screen.dart';
import 'package:swingmate/features/notification/presentation/screens/notification_screen.dart';
import 'package:swingmate/features/setup/presentation/setup_page.dart';

/// 경로와 화면의 연결만 관리한다.
///
/// 앱 초기화 및 인증 상태에 따른 접근 제어는 [app_router.dart]의
/// GoRouter 설정에서 담당한다.
abstract final class AppRouteDefinitions {
  static List<RouteBase> get routes => [
    GoRoute(
      path: AppRoutes.loginPath,
      name: AppRoutes.loginName,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.roleSelectionPath,
      name: AppRoutes.roleSelectionName,
      builder: (context, state) => const RoleSelectionScreen(),
    ),
    GoRoute(
      path: AppRoutes.proProfilePath,
      name: AppRoutes.proProfileName,
      builder: (context, state) => const ProProfileScreen(),
    ),
    GoRoute(
      path: AppRoutes.proCareerPath,
      name: AppRoutes.proCareerName,
      builder: (context, state) => const ProCareerScreen(),
    ),
    GoRoute(
      path: AppRoutes.proAvailabilityPath,
      name: AppRoutes.proAvailabilityName,
      builder: (context, state) => const ProAvailabilityScreen(),
    ),
    GoRoute(
      path: AppRoutes.memberProfilePath,
      name: AppRoutes.memberProfileName,
      builder: (context, state) => const MemberProfileScreen(),
    ),
    GoRoute(
      path: AppRoutes.phoneVerificationPath,
      name: AppRoutes.phoneVerificationName,
      builder: (context, state) => PhoneVerificationScreen(
        phoneNumber: state.extra as String? ?? '010-1234-5678',
        isProSignup: state.uri.queryParameters['role'] == 'pro',
      ),
    ),
    GoRoute(
      path: AppRoutes.lessonPreferencesPath,
      name: AppRoutes.lessonPreferencesName,
      builder: (context, state) => const LessonPreferencesScreen(),
    ),
    GoRoute(
      path: AppRoutes.proCodeConnectionPath,
      name: AppRoutes.proCodeConnectionName,
      builder: (context, state) => const ProCodeConnectionScreen(),
    ),
    GoRoute(
      path: AppRoutes.proConnectionSuccessPath,
      name: AppRoutes.proConnectionSuccessName,
      builder: (context, state) => const ProConnectionSuccessScreen(),
    ),
    GoRoute(
      path: AppRoutes.proConnectionFailurePath,
      name: AppRoutes.proConnectionFailureName,
      builder: (context, state) => const ProConnectionFailureScreen(),
    ),
    GoRoute(
      path: AppRoutes.homePath,
      name: AppRoutes.homeName,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: AppRoutes.notificationsPath,
      name: AppRoutes.notificationsName,
      builder: (context, state) => const NotificationScreen(),
    ),
    GoRoute(
      path: AppRoutes.setupPath,
      name: AppRoutes.setupName,
      builder: (context, state) => const SetupPage(),
    ),
  ];
}
