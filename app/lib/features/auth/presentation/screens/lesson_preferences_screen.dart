import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:swingmate/app/router/app_routes.dart';
import 'package:swingmate/app/theme/app_colors.dart';
import 'package:swingmate/features/auth/di/providers/signup_flow_providers.dart';
import 'package:swingmate/features/auth/presentation/helpers/signup_messages.dart';
import 'package:swingmate/features/auth/presentation/widgets/golf_experience_option.dart';
import 'package:swingmate/features/auth/presentation/widgets/lesson_interest_chip.dart';
import 'package:swingmate/features/auth/presentation/widgets/onboarding_header.dart';

class LessonPreferencesScreen extends ConsumerStatefulWidget {
  const LessonPreferencesScreen({super.key});

  @override
  ConsumerState<LessonPreferencesScreen> createState() =>
      _LessonPreferencesScreenState();
}

class _LessonPreferencesScreenState
    extends ConsumerState<LessonPreferencesScreen> {
  static const _interests = [
    '초보',
    '스윙 교정',
    '숏게임',
    '드라이버',
    '아이언',
    '퍼팅',
    '로프트샷',
    '스팅어샷',
    '기타',
  ];

  static const _experiences = ['6개월 미만', '6개월 ~ 3년', '3년 ~ 7년', '7년 이상'];

  @override
  Widget build(BuildContext context) {
    final memberDraft = ref.watch(
      signupFlowViewModelProvider.select((state) => state.member),
    );

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
                          '프로에게 무엇을\n배우고 싶나요?',
                          style: TextStyle(
                            color: AppColors.ink,
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            height: 32 / 24,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '프로가 레슨할때 참고할 정보예요.',
                          style: TextStyle(
                            color: AppColors.secondaryText,
                            fontSize: 18,
                            height: 28 / 18,
                          ),
                        ),
                        const SizedBox(height: 48),
                        _buildInterestSection(memberDraft.selectedInterests),
                        const SizedBox(height: 32),
                        _buildExperienceSection(memberDraft.selectedExperience),
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInterestSection(Set<String> selectedInterests) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: '관심 레슨 분야 ',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              TextSpan(
                text: '(복수 선택 가능)',
                style: TextStyle(
                  color: AppColors.secondaryText,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          style: TextStyle(color: AppColors.ink, fontSize: 18),
        ),
        const SizedBox(height: 16),
        Column(
          children: [
            for (var row = 0; row < 3; row++) ...[
              if (row > 0) const SizedBox(height: 8),
              Row(
                children: [
                  for (var column = 0; column < 3; column++) ...[
                    if (column > 0) const SizedBox(width: 12),
                    LessonInterestChip(
                      label: _interests[row * 3 + column],
                      isSelected: selectedInterests.contains(
                        _interests[row * 3 + column],
                      ),
                      onTap: () =>
                          _toggleInterest(_interests[row * 3 + column]),
                    ),
                  ],
                ],
              ),
            ],
          ],
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
        const SizedBox(height: 8),
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

  void _toggleInterest(String interest) {
    ref.read(signupFlowViewModelProvider.notifier).toggleInterest(interest);
  }

  void _goBack() {
    if (context.canPop()) {
      context.pop();
      return;
    }

    context.goNamed(AppRoutes.phoneVerificationName);
  }

  void _continue() {
    final validationError = ref
        .read(signupFlowViewModelProvider.notifier)
        .validateLessonPreferences();
    if (validationError != null) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(validationError.message)));
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..clearSnackBars();
    context.pushNamed(AppRoutes.proCodeConnectionName);
  }
}
