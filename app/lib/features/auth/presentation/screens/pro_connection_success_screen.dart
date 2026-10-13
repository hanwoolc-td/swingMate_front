import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:swingmate/app/router/app_routes.dart';
import 'package:swingmate/app/theme/app_colors.dart';
import 'package:swingmate/core/theme/app_assets.dart';
import 'package:swingmate/features/auth/presentation/widgets/onboarding_header.dart';

class ProConnectionSuccessScreen extends StatelessWidget {
  const ProConnectionSuccessScreen({super.key});

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
                  child: Stack(
                    clipBehavior: Clip.hardEdge,
                    children: [
                      const Positioned(
                        left: -110,
                        top: 229,
                        child: _SuccessSvg(asset: AppAssets.successEllipse),
                      ),
                      const Positioned(
                        left: 155,
                        top: -27,
                        child: _SuccessSvg(asset: AppAssets.successGroup),
                      ),
                      const Positioned(
                        left: 309,
                        top: 63,
                        child: _SuccessSvg(asset: AppAssets.successGolfCourse),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
                        child: Column(
                          children: [
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      '내가 찾는 프로가 맞나요?',
                                      style: TextStyle(
                                        color: AppColors.ink,
                                        fontSize: 24,
                                        fontWeight: FontWeight.w600,
                                        height: 32 / 24,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    const Text(
                                      '프로 정보를 확인하고 연결해보세요.',
                                      style: TextStyle(
                                        color: AppColors.secondaryText,
                                        fontSize: 18,
                                        height: 26 / 18,
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                    const _ProProfileCard(),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            _SuccessButton(
                              label: '연결하기',
                              onPressed: () =>
                                  context.goNamed(AppRoutes.homeName),
                            ),
                            const SizedBox(height: 12),
                            _SuccessButton(
                              label: '다시 입력하기',
                              isSecondary: true,
                              onPressed: () => context.goNamed(
                                AppRoutes.proCodeConnectionName,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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

class _ProProfileCard extends StatelessWidget {
  const _ProProfileCard();

  static const _tags = ['#어드레스', '#아이언', '#드라이버', '#스윙 교정', '#비거리 향상'];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildProfileHeader(),
          const SizedBox(height: 20),
          SvgPicture.asset(AppAssets.successLine),
          const SizedBox(height: 20),
          const Text(
            '“기본에 충실한 스윙으로,\n지속 가능한 골프를 함께 만들어갑니다.”',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.secondaryText,
              fontSize: 16,
              fontWeight: FontWeight.w500,
              height: 26 / 16,
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 12,
            children: [for (final tag in _tags) _Tag(label: tag)],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        Container(
          width: 148,
          height: 148,
          padding: const EdgeInsets.all(4),
          decoration: const BoxDecoration(
            color: AppColors.surface,
            shape: BoxShape.circle,
          ),
          child: ClipOval(
            child: Image.asset(AppAssets.proPhoto, fit: BoxFit.cover),
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          '김도윤 프로',
          style: TextStyle(
            color: AppColors.ink,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'KPGA 프로 · 8년 경력',
          style: TextStyle(
            color: AppColors.secondaryText,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            height: 14 / 16,
          ),
        ),
      ],
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.border,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.tagForeground,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          height: 18 / 14,
        ),
      ),
    );
  }
}

class _SuccessButton extends StatelessWidget {
  const _SuccessButton({
    required this.label,
    required this.onPressed,
    this.isSecondary = false,
  });

  final String label;
  final VoidCallback onPressed;
  final bool isSecondary;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: isSecondary
              ? AppColors.inputBackground
              : AppColors.action,
          foregroundColor: isSecondary ? AppColors.ink : AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: TextStyle(
            fontSize: 18,
            fontWeight: isSecondary ? FontWeight.w500 : FontWeight.w700,
          ),
        ),
        child: Text(label),
      ),
    );
  }
}

class _SuccessSvg extends StatelessWidget {
  const _SuccessSvg({required this.asset});

  final String asset;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(asset);
  }
}
