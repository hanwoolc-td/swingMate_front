import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:swingmate/app/router/app_routes.dart';
import 'package:swingmate/app/theme/app_colors.dart';
import 'package:swingmate/core/theme/app_assets.dart';
import 'package:swingmate/features/auth/presentation/widgets/onboarding_header.dart';

class ProConnectionFailureScreen extends StatelessWidget {
  const ProConnectionFailureScreen({super.key});

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
                OnboardingHeader(onBack: () => context.pop()),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
                    child: Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  '코드와 일치하는\n프로를 찾을 수 없습니다.',
                                  style: TextStyle(
                                    color: AppColors.ink,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
                                    height: 33 / 24,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                const Text(
                                  '입력하신 코드와 일치하는 프로가 없습니다.\n코드를 다시 확인하고 입력해주세요.',
                                  style: TextStyle(
                                    color: AppColors.secondaryText,
                                    fontSize: 18,
                                    height: 27 / 18,
                                  ),
                                ),
                                const SizedBox(height: 48),
                                Center(
                                  child: SvgPicture.asset(
                                    AppAssets.errorExclamation,
                                  ),
                                ),
                                const SizedBox(height: 48),
                                const _FailureGuide(),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: FilledButton(
                            onPressed: () => context.goNamed(
                              AppRoutes.proCodeConnectionName,
                            ),
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
                            child: const Text('다시 입력하기'),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: FilledButton(
                            onPressed: () => context.goNamed(
                              AppRoutes.homeName,
                            ),
                            style: FilledButton.styleFrom(
                              backgroundColor: AppColors.inputBackground,
                              foregroundColor: AppColors.ink,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              textStyle: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            child: const Text('나중에 연결하기'),
                          ),
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
    );
  }
}

class _FailureGuide extends StatelessWidget {
  const _FailureGuide();

  static const _items = [
    '코드의 띄어쓰기나 오타를 확인해주세요.',
    '프로에게 받은 최신 코드를 입력해주세요.',
    '문제가 계속 발생하면 프로에게 다시 코드를 요청하거나 고객센터에 문의해주세요.',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      decoration: BoxDecoration(
        color: AppColors.roleCardBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var index = 0; index < _items.length; index++) ...[
            if (index > 0) const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 16,
                  child: Text(
                    '·',
                    style: TextStyle(
                      color: AppColors.secondaryText,
                      fontSize: 16,
                      height: 1,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    _items[index],
                    style: const TextStyle(
                      color: AppColors.secondaryText,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      height: 24 / 14,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
