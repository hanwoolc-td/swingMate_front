import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:swingmate/app/router/app_routes.dart';
import 'package:swingmate/app/theme/app_colors.dart';
import 'package:swingmate/core/theme/app_assets.dart';
import 'package:swingmate/features/auth/presentation/widgets/login_logo_placeholder.dart';
import 'package:swingmate/features/auth/presentation/widgets/social_login_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 393),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final bottomSpacing = constraints.maxHeight >= 620
                      ? 116.0
                      : 32.0;

                  return Column(
                    children: [
                      const Expanded(
                        child: Center(child: LoginLogoPlaceholder()),
                      ),
                      SocialLoginButton(
                        label: '카카오 로그인',
                        iconAsset: AppAssets.loginKakao,
                        iconIsSvg: true,
                        backgroundColor: AppColors.kakao,
                        foregroundColor: AppColors.kakaoForeground,
                        onPressed: () => _showRoleSelection(context),
                      ),
                      const SizedBox(height: 16),
                      SocialLoginButton(
                        label: 'Google 로그인',
                        iconAsset: AppAssets.loginGoogle,
                        iconLeft: 19,
                        backgroundColor: AppColors.surface,
                        foregroundColor: AppColors.ink,
                        borderColor: AppColors.borderSubtle,
                        shadowBlurRadius: 8,
                        fontWeight: FontWeight.w500,
                        onPressed: () => _showRoleSelection(context),
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () => _showComingSoon(context, '로그인 도움말'),
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.ink,
                          minimumSize: Size.zero,
                          padding: EdgeInsets.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          textStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            height: 20 / 14,
                          ),
                        ),
                        child: const Text('로그인하는데 어려움이 있으신가요?'),
                      ),
                      SizedBox(height: bottomSpacing),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void _showComingSoon(BuildContext context, String feature) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text('$feature 기능은 다음 단계에서 연결합니다.')));
}

void _showRoleSelection(BuildContext context) {
  context.pushNamed(AppRoutes.roleSelectionName);
}
