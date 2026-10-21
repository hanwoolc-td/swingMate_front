import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:swingmate/app/router/app_routes.dart';
import 'package:swingmate/app/theme/app_colors.dart';
import 'package:swingmate/core/theme/app_assets.dart';
import 'package:swingmate/features/auth/di/providers/signup_flow_providers.dart';
import 'package:swingmate/features/auth/presentation/states/signup_flow_state.dart';
import 'package:swingmate/features/auth/presentation/widgets/onboarding_header.dart';
import 'package:swingmate/features/auth/presentation/widgets/role_selection_card.dart';

class RoleSelectionScreen extends ConsumerStatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  ConsumerState<RoleSelectionScreen> createState() =>
      _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends ConsumerState<RoleSelectionScreen> {
  bool _isMember = true;

  @override
  void initState() {
    super.initState();
    _isMember = ref.read(signupFlowViewModelProvider).role != SignupRole.pro;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          ref.read(signupFlowViewModelProvider.notifier).reset();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.surface,
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 393),
              child: Column(
                children: [
                  OnboardingHeader(onBack: _goBack),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '어떤 역할로 시작할까요?',
                            style: TextStyle(
                              color: AppColors.ink,
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              height: 32 / 24,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            '역할에 맞는 기능을 제공해요.',
                            style: TextStyle(
                              color: AppColors.secondaryText,
                              fontSize: 18,
                              height: 28 / 18,
                            ),
                          ),
                          const SizedBox(height: 32),
                          RoleSelectionCard(
                            key: const ValueKey('role-selection-member'),
                            title: '회원으로 시작하기',
                            iconAsset: AppAssets.roleMember,
                            selected: _isMember,
                            onTap: () => _selectAndContinue(SignupRole.member),
                          ),
                          const SizedBox(height: 12),
                          RoleSelectionCard(
                            key: const ValueKey('role-selection-pro'),
                            title: '프로로 시작하기',
                            iconAsset: AppAssets.rolePro,
                            selected: !_isMember,
                            onTap: () => _selectAndContinue(SignupRole.pro),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _goBack() {
    if (context.canPop()) {
      context.pop();
      return;
    }

    // 역할 선택 화면이 스택의 첫 화면으로 열려 pop할 대상이 없을 때만 실행되는 예외처리
    // 거의 발생하지 않지만, 테스트 환경에서 발생할 수 있음
    ref.read(signupFlowViewModelProvider.notifier).reset();
    context.goNamed(AppRoutes.loginName);
  }

  void _selectAndContinue(SignupRole role) {
    setState(() => _isMember = role == SignupRole.member);
    ref.read(signupFlowViewModelProvider.notifier).selectRole(role);
    if (role == SignupRole.member) {
      context.pushNamed(AppRoutes.memberProfileName);
      return;
    }

    context.pushNamed(AppRoutes.proProfileName);
  }
}
