import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:swingmate/app/router/app_routes.dart';
import 'package:swingmate/app/theme/app_colors.dart';
import 'package:swingmate/features/auth/di/providers/signup_flow_providers.dart';
import 'package:swingmate/features/auth/presentation/helpers/signup_messages.dart';
import 'package:swingmate/features/auth/presentation/states/signup_flow_state.dart';
import 'package:swingmate/features/auth/presentation/widgets/lesson_interest_chip.dart';
import 'package:swingmate/features/auth/presentation/widgets/onboarding_header.dart';

class LessonInterestsScreen extends ConsumerWidget {
  const LessonInterestsScreen({super.key});

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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final memberDraft = ref.watch(
      signupFlowViewModelProvider.select((state) => state.member),
    );
    final canContinue = memberDraft.selectedInterests.isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 393),
            child: Column(
              children: [
                OnboardingHeader(onBack: () => context.pop()),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '어떤 레슨을 받고 싶나요?',
                          style: TextStyle(
                            color: AppColors.ink,
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            height: 32 / 24,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '관심 분야를 모두 선택해주세요.',
                          style: TextStyle(
                            color: AppColors.secondaryText,
                            fontSize: 18,
                            height: 28 / 18,
                          ),
                        ),
                        const SizedBox(height: 48),
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
                        for (var row = 0; row < 3; row++) ...[
                          if (row > 0) const SizedBox(height: 8),
                          Row(
                            children: [
                              for (var column = 0; column < 3; column++) ...[
                                if (column > 0) const SizedBox(width: 12),
                                LessonInterestChip(
                                  label: _interests[row * 3 + column],
                                  isSelected: memberDraft.selectedInterests
                                      .contains(_interests[row * 3 + column]),
                                  onTap: () => ref
                                      .read(
                                        signupFlowViewModelProvider.notifier,
                                      )
                                      .toggleInterest(
                                        _interests[row * 3 + column],
                                      ),
                                ),
                              ],
                            ],
                          ),
                        ],
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
                      onPressed: canContinue
                          ? () => _completeSignup(context, ref)
                          : null,
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

  Future<void> _completeSignup(BuildContext context, WidgetRef ref) async {
    final validationError = ref
        .read(signupFlowViewModelProvider.notifier)
        .validateLessonPreferences();
    if (validationError != null) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(validationError.message)));
      return;
    }

    final isCompleted = await ref
        .read(signupFlowViewModelProvider.notifier)
        .completeMemberSignup();
    if (!context.mounted) return;

    if (!isCompleted) {
      final failure = ref.read(signupFlowViewModelProvider).submissionFailure;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(failure?.message ?? SubmissionFailure.unknown.message),
        ),
      );
      return;
    }
    context.pushNamed(AppRoutes.proCodeConnectionName);
  }
}
