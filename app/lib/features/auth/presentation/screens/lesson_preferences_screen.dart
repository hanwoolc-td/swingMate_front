import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:swingmate/app/router/app_routes.dart';
import 'package:swingmate/app/theme/app_colors.dart';
import 'package:swingmate/features/auth/di/providers/signup_flow_providers.dart';
import 'package:swingmate/features/auth/presentation/states/signup_flow_state.dart';
import 'package:swingmate/features/auth/presentation/widgets/golf_experience_option.dart';
import 'package:swingmate/features/auth/presentation/widgets/onboarding_header.dart';

class LessonPreferencesScreen extends ConsumerStatefulWidget {
  const LessonPreferencesScreen({super.key});

  @override
  ConsumerState<LessonPreferencesScreen> createState() =>
      _LessonPreferencesScreenState();
}

class _LessonPreferencesScreenState
    extends ConsumerState<LessonPreferencesScreen> {
  static const _experiences = [
    '아직 시작 전',
    '6개월 미만',
    '6개월 ~ 1년',
    '1 ~ 3년',
    '3 ~ 7년',
    '7년 이상',
  ];

  static const _scores = [
    '라운드 경험 없음',
    '120타 이상',
    '100 ~ 119타',
    '90 ~ 99타',
    '80 ~ 89타',
    '79타 이하',
  ];

  String? _selectedScore;

  @override
  Widget build(BuildContext context) {
    final memberDraft = ref.watch(
      signupFlowViewModelProvider.select((state) => state.member),
    );
    final canContinue =
        memberDraft.selectedExperience != null && _selectedScore != null;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 393),
            child: Column(
              children: [
                OnboardingHeader(onBack: _goBack),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '골프를 시작한지 얼마나 되셨나요?',
                          style: TextStyle(
                            color: AppColors.ink,
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            height: 32 / 24,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '회원님에게 맞는 레슨을 준비하는 데 활용돼요.',
                          style: TextStyle(
                            color: AppColors.secondaryText,
                            fontSize: 18,
                            height: 28 / 18,
                          ),
                        ),
                        const SizedBox(height: 48),
                        _buildExperienceSection(memberDraft.selectedExperience),
                        const SizedBox(height: 48),
                        _buildScoreSection(),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  child: SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: FilledButton(
                      onPressed: canContinue ? _continue : null,
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.action,
                        foregroundColor: AppColors.surface,
                        disabledBackgroundColor: AppColors.border,
                        disabledForegroundColor: AppColors.navigationInactive,
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScoreSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '평균 스코어 (18홀 기준)',
          style: TextStyle(
            color: AppColors.ink,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 16),
        for (final score in _scores)
          GolfExperienceOption(
            label: score,
            isSelected: _selectedScore == score,
            onTap: () => setState(() => _selectedScore = score),
          ),
      ],
    );
  }

  Widget _buildExperienceSection(String? selectedExperience) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '골프 경력',
          style: TextStyle(
            color: AppColors.ink,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 16),
        for (final experience in _experiences)
          GolfExperienceOption(
            label: experience,
            isSelected: selectedExperience == experience,
            onTap: () => ref
                .read(signupFlowViewModelProvider.notifier)
                .selectExperience(experience),
          ),
      ],
    );
  }

  void _goBack() {
    if (context.canPop()) {
      context.pop();
      return;
    }

    context.goNamed(AppRoutes.phoneVerificationName);
  }

  Future<void> _continue() async {
    context.pushNamed(AppRoutes.lessonInterestsName);
  }
}
