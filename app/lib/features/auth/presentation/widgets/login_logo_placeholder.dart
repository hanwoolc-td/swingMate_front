import 'package:flutter/material.dart';
import 'package:swingmate/app/theme/app_colors.dart';

/// 로그인 화면에서 사용하는 SwingMate 텍스트 로고.
class LoginLogoPlaceholder extends StatelessWidget {
  const LoginLogoPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'SwingMate 로고',
      child: SizedBox(
        width: 220,
        height: 180,
        child: Center(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: const Text(
              'SwingMate',
              style: TextStyle(
                color: AppColors.ink,
                fontFamily: 'Caveat',
                fontSize: 64,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
