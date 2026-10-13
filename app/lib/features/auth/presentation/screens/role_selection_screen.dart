import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:swingmate/app/router/app_routes.dart';
import 'package:swingmate/app/theme/app_colors.dart';
import 'package:swingmate/core/theme/app_assets.dart';
import 'package:swingmate/features/auth/presentation/widgets/onboarding_header.dart';
import 'package:swingmate/features/auth/presentation/widgets/role_selection_card.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  bool _isMember = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 393),
            child: Column(
              children: [
                OnboardingHeader(onBack: _goBack),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final compact = constraints.maxHeight < 560;
                      final content = Padding(
                        padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '회원으로 시작할까요,\n프로로 시작할까요?',
                              style: TextStyle(
                                color: AppColors.ink,
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                height: 32 / 24,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              '회원과 프로, 각자의 필요에 맞는\n기능을 제공해요.',
                              style: TextStyle(
                                color: AppColors.secondaryText,
                                fontSize: 18,
                                height: 24 / 18,
                              ),
                            ),
                            const SizedBox(height: 32),
                            RoleSelectionCard(
                              key: const ValueKey('role-selection-member'),
                              title: '회원으로 시작하기',
                              description: '레슨을 예약하고,\n나만의 레슨 기록을 확인해요.',
                              iconAsset: AppAssets.onboardingMember,
                              iconHasBackground: true,
                              selected: _isMember,
                              onTap: () => setState(() => _isMember = true),
                            ),
                            const SizedBox(height: 20),
                            RoleSelectionCard(
                              key: const ValueKey('role-selection-pro'),
                              title: '프로로 시작하기',
                              description: '레슨을 관리하고,\n회원의 성장 과정을 기록해요.',
                              iconAsset: AppAssets.onboardingPro,
                              selected: !_isMember,
                              onTap: () => setState(() => _isMember = false),
                            ),
                            if (compact)
                              const SizedBox(height: 24)
                            else
                              const Spacer(),
                            SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: FilledButton(
                                onPressed: _continue,
                                style: FilledButton.styleFrom(
                                  backgroundColor: AppColors.action,
                                  foregroundColor: AppColors.surface,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  textStyle: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                child: const Text('다음'),
                              ),
                            ),
                          ],
                        ),
                      );

                      if (!compact) {
                        return content;
                      }

                      return SingleChildScrollView(child: content);
                    },
                  ),
                ),
              ],
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

    context.goNamed(AppRoutes.loginName);
  }

  void _continue() {
    if (_isMember) {
      context.pushNamed(AppRoutes.memberProfileName);
      return;
    }

    context.pushNamed(AppRoutes.proProfileName);
  }
}
