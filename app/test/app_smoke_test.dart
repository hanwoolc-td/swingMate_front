import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:swingmate/app/app.dart';
import 'package:swingmate/app/router/app_router.dart';
import 'package:swingmate/app/router/app_routes.dart';
import 'package:swingmate/core/config/app_config.dart';
import 'package:swingmate/features/auth/presentation/widgets/login_logo_placeholder.dart';
import 'package:swingmate/features/auth/presentation/widgets/role_selection_card.dart';
import 'package:swingmate/features/auth/presentation/screens/member_profile_screen.dart';
import 'package:swingmate/features/auth/presentation/screens/phone_verification_screen.dart';
import 'package:swingmate/features/auth/presentation/screens/pro_profile_screen.dart';
import 'package:swingmate/features/auth/presentation/screens/pro_career_screen.dart';
import 'package:swingmate/features/auth/presentation/screens/pro_availability_screen.dart';
import 'package:swingmate/features/home/di/providers/home_providers.dart';
import 'package:swingmate/features/home/domain/entities/home_dashboard.dart';
import 'package:swingmate/features/home/domain/repositories/home_repository.dart';

void main() {
  testWidgets('Figma 로그인 화면과 로고 자리를 표시한다', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: SwingMateApp()));
    await tester.pumpAndSettle();

    expect(find.byType(LoginLogoPlaceholder), findsOneWidget);
    expect(find.text('카카오 로그인'), findsOneWidget);
    expect(find.text('Google 로그인'), findsOneWidget);
    expect(find.text('Apple로 로그인'), findsOneWidget);
    expect(find.text('로그인하는데 어려움이 있으신가요?'), findsOneWidget);
  });

  testWidgets('소셜 로그인 버튼에서 역할 선택 화면으로 이동한다', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: SwingMateApp()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('카카오 로그인'));
    await tester.pumpAndSettle();

    expect(find.text('회원으로 시작할까요,\n프로로 시작할까요?'), findsOneWidget);
    expect(find.text('회원으로 시작하기'), findsOneWidget);
    expect(find.text('프로로 시작하기'), findsOneWidget);
    expect(find.text('다음'), findsOneWidget);

    await tester.tap(find.text('다음'));
    await tester.pumpAndSettle();
    expect(find.byType(MemberProfileScreen), findsOneWidget);
    expect(find.text('프로에게 자신을\n소개해보세요.'), findsOneWidget);
    expect(find.text('프로필 사진'), findsOneWidget);
    expect(find.text('인증번호 받기'), findsOneWidget);

    final requestCodeButton = find.text('인증번호 받기');
    await tester.ensureVisible(requestCodeButton);
    await tester.tap(requestCodeButton);
    await tester.pumpAndSettle();
    expect(find.byType(PhoneVerificationScreen), findsOneWidget);
    expect(find.text('휴대폰 번호를\n인증해주세요.'), findsOneWidget);
    expect(find.text('인증번호 재전송'), findsOneWidget);
    expect(find.text('인증하기'), findsOneWidget);

    await tester.tap(find.bySemanticsLabel('뒤로 가기'));
    await tester.pumpAndSettle();
    await tester.tap(find.bySemanticsLabel('뒤로 가기'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('프로로 시작하기'));
    await tester.pump();
    expect(
      tester
          .widget<RoleSelectionCard>(
            find.byKey(const ValueKey('role-selection-pro')),
          )
          .selected,
      isTrue,
    );

    await tester.tap(find.text('다음'));
    await tester.pumpAndSettle();
    expect(find.byType(ProProfileScreen), findsOneWidget);
    expect(find.text('회원들에게 자신을\n소개해보세요.'), findsOneWidget);
    expect(find.text('프로필 사진과 기본 정보를 입력해 주세요.'), findsOneWidget);
    expect(find.text('프로필 사진'), findsOneWidget);
    expect(find.text('인증번호 받기'), findsOneWidget);

    await tester.tap(find.bySemanticsLabel('뒤로 가기'));
    await tester.pumpAndSettle();
    expect(find.text('회원으로 시작할까요,\n프로로 시작할까요?'), findsOneWidget);

    await tester.tap(find.bySemanticsLabel('뒤로 가기'));
    await tester.pumpAndSettle();
    expect(find.text('카카오 로그인'), findsOneWidget);
  });

  testWidgets('Figma 홈과 Fake Repository 데이터가 표시된다', (tester) async {
    const config = AppConfig(
      environment: AppEnvironment.development,
      apiBaseUrl: 'https://api.example.test',
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [appConfigProvider.overrideWithValue(config)],
        child: const SwingMateApp(),
      ),
    );

    _goToHome(tester);
    await tester.pumpAndSettle();

    expect(find.text('SwingMate'), findsOneWidget);
    expect(find.text('다가오는 레슨'), findsOneWidget);
    expect(find.text('레슨 예약'), findsOneWidget);
    expect(find.text('내 레슨권'), findsOneWidget);
    expect(find.text('레슨권 추가'), findsOneWidget);

    await tester.drag(find.byType(ListView), const Offset(0, -600));
    await tester.pumpAndSettle();
    expect(find.text('최근 레슨 기록'), findsOneWidget);
    expect(find.text('홈'), findsOneWidget);
  });

  testWidgets('프로 경력 화면의 안내 문구를 표시한다', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: SwingMateApp()));
    await tester.pumpAndSettle();

    final context = tester.element(find.byType(SwingMateApp));
    ProviderScope.containerOf(context)
        .read(appRouterProvider)
        .goNamed(AppRoutes.proCareerName);
    await tester.pumpAndSettle();

    expect(find.byType(ProCareerScreen), findsOneWidget);
    expect(find.text('회원들에게 자신을\n소개해보세요.'), findsOneWidget);
    expect(find.text('자신의 경력을 소개해보세요.'), findsOneWidget);
  });

  testWidgets('프로 경력 소개 화면을 표시하고 경력을 추가한다', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: SwingMateApp()));
    await tester.pumpAndSettle();

    final context = tester.element(find.byType(SwingMateApp));
    ProviderScope.containerOf(context)
        .read(appRouterProvider)
        .goNamed(AppRoutes.proCareerName);
    await tester.pumpAndSettle();

    expect(find.byType(ProCareerScreen), findsOneWidget);
    expect(find.text('회원들에게 자신을\n소개해보세요.'), findsOneWidget);
    expect(find.text('자신의 경력을 소개해보세요.'), findsOneWidget);
    expect(find.text('간단한 자기소개를 입력해주세요.\n(최대 200자)'), findsOneWidget);
    expect(find.text('경력 추가'), findsOneWidget);

    await tester.tap(find.text('다음'));
    await tester.pumpAndSettle();
    expect(find.text('프로 소개를 입력해주세요.'), findsOneWidget);
    expect(find.text('경력을 하나 이상 입력해주세요.'), findsOneWidget);

    final addCareerButton = find.text('경력 추가');
    await tester.ensureVisible(addCareerButton);
    await tester.tap(addCareerButton);
    await tester.pumpAndSettle();
    expect(find.byType(TextField), findsNWidgets(3));

    await tester.enterText(find.byType(TextField).at(0), 'KPGA 투어 프로입니다.');
    await tester.enterText(find.byType(TextField).at(1), 'KPGA 투어 프로');
    await tester.tap(find.text('다음'));
    await tester.pumpAndSettle();
    expect(find.byType(ProAvailabilityScreen), findsOneWidget);
  });

  testWidgets('프로 소개 화면에서 정보를 입력하고 인증 화면으로 이동한다', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: SwingMateApp()));
    await tester.pumpAndSettle();

    final context = tester.element(find.byType(SwingMateApp));
    ProviderScope.containerOf(context)
        .read(appRouterProvider)
        .goNamed(AppRoutes.proProfileName);
    await tester.pumpAndSettle();

    expect(find.byType(ProProfileScreen), findsOneWidget);
    expect(find.text('회원들에게 자신을\n소개해보세요.'), findsOneWidget);
    expect(find.text('프로필 사진과 기본 정보를 입력해 주세요.'), findsOneWidget);
    expect(find.bySemanticsLabel('프로필 사진 추가'), findsOneWidget);

    final fields = find.byType(TextField);
    expect(fields, findsNWidgets(2));
    expect(
      tester.widget<TextField>(fields.at(1)).keyboardType,
      TextInputType.phone,
    );

    await tester.enterText(fields.at(0), '홍길동');
    await tester.enterText(fields.at(1), '01012345678');
    await tester.tap(find.text('인증번호 받기'));
    await tester.pump();
    await tester.pump();

    expect(find.byType(PhoneVerificationScreen), findsOneWidget);
    expect(find.text('010-1234-5678로 인증번호를 보냈습니다.'), findsOneWidget);
  });

  testWidgets('회원 프로필 입력은 역할 선택 화면에 다녀와도 유지된다', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: SwingMateApp()));
    await tester.pumpAndSettle();

    final context = tester.element(find.byType(SwingMateApp));
    ProviderScope.containerOf(context)
        .read(appRouterProvider)
        .goNamed(AppRoutes.memberProfileName);
    await tester.pumpAndSettle();

    final fields = find.byType(TextField);
    await tester.enterText(fields.at(0), '홍길동');
    await tester.enterText(fields.at(1), '01012345678');

    await tester.tap(find.bySemanticsLabel('뒤로 가기'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('다음'));
    await tester.pumpAndSettle();

    expect(find.byType(MemberProfileScreen), findsOneWidget);
    expect(find.text('홍길동'), findsOneWidget);
    expect(find.text('01012345678'), findsOneWidget);
  });

  testWidgets('프로 예약 가능 시간의 공통 및 요일별 설정 형식을 전환한다', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: SwingMateApp()));
    await tester.pumpAndSettle();

    final context = tester.element(find.byType(SwingMateApp));
    ProviderScope.containerOf(context)
        .read(appRouterProvider)
        .goNamed(AppRoutes.proAvailabilityName);
    await tester.pumpAndSettle();

    expect(find.byType(ProAvailabilityScreen), findsOneWidget);
    expect(find.text('예약 가능한 시간을\n설정해보세요.'), findsOneWidget);
    expect(find.text('요일별로 다르게 설정하기'), findsOneWidget);
    expect(find.text('09:00'), findsOneWidget);
    expect(find.text('13:00'), findsOneWidget);

    final daySpecificButton = find.text('요일별로 다르게 설정하기');
    await tester.ensureVisible(daySpecificButton);
    await tester.tap(daySpecificButton);
    await tester.pumpAndSettle();

    expect(find.text('모든 요일에 같은 시간 적용하기'), findsOneWidget);
    expect(find.text('월요일'), findsOneWidget);
    expect(find.text('화요일'), findsOneWidget);
    expect(find.text('수요일'), findsOneWidget);
    expect(find.text('시작 시간'), findsNothing);
    expect(find.text('종료 시간'), findsNothing);

    final wednesdayCard = find.text('수요일');
    await tester.ensureVisible(wednesdayCard);
    await tester.tap(wednesdayCard);
    await tester.pumpAndSettle();
    expect(find.text('시작 시간'), findsOneWidget);
    expect(find.text('종료 시간'), findsOneWidget);
  });

  testWidgets('빈 홈 상태를 표시한다', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          homeRepositoryProvider.overrideWithValue(
            const _EmptyHomeRepository(),
          ),
        ],
        child: const SwingMateApp(),
      ),
    );
    _goToHome(tester);
    await tester.pumpAndSettle();

    expect(find.text('예정된 레슨이 없어요'), findsOneWidget);
    expect(find.text('사용 중인 레슨권이 없어요'), findsOneWidget);
  });

  testWidgets('홈 오류 상태와 다시 시도를 표시한다', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          homeRepositoryProvider.overrideWithValue(
            const _ErrorHomeRepository(),
          ),
        ],
        child: const SwingMateApp(),
      ),
    );
    _goToHome(tester);
    await tester.pumpAndSettle();

    expect(find.text('홈 정보를 불러오지 못했어요'), findsOneWidget);
    expect(find.text('다시 시도'), findsOneWidget);
  });

  testWidgets('등록되지 않은 경로에 안내 화면을 표시한다', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          homeRepositoryProvider.overrideWithValue(
            const _EmptyHomeRepository(),
          ),
        ],
        child: const SwingMateApp(),
      ),
    );

    final context = tester.element(find.byType(SwingMateApp));
    final container = ProviderScope.containerOf(context);
    container.read(appRouterProvider).go('/unknown');
    await tester.pumpAndSettle();

    expect(find.text('페이지를 찾을 수 없어요'), findsOneWidget);
    expect(find.text('홈으로 이동'), findsOneWidget);
  });
}

void _goToHome(WidgetTester tester) {
  final context = tester.element(find.byType(SwingMateApp));
  final container = ProviderScope.containerOf(context);
  container.read(appRouterProvider).goNamed(AppRoutes.homeName);
}

class _EmptyHomeRepository implements HomeRepository {
  const _EmptyHomeRepository();

  @override
  Future<HomeDashboard> fetchDashboard() async {
    return const HomeDashboard(
      memberName: '백진규',
      lessonPasses: [],
      recentLessons: [],
    );
  }
}

class _ErrorHomeRepository implements HomeRepository {
  const _ErrorHomeRepository();

  @override
  Future<HomeDashboard> fetchDashboard() {
    return Future.error(StateError('test error'));
  }
}
