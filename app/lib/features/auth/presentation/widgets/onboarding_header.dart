import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:swingmate/app/theme/app_colors.dart';
import 'package:swingmate/core/theme/app_assets.dart';

class OnboardingHeader extends StatelessWidget {
  const OnboardingHeader({required this.onBack, super.key});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Semantics(
              button: true,
              label: '뒤로 가기',
              child: InkResponse(
                onTap: onBack,
                radius: 20,
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: Center(child: SvgPicture.asset(AppAssets.chevronLeft)),
                ),
              ),
            ),
            const Expanded(
              child: Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'SwingMate',
                    style: TextStyle(
                      color: AppColors.ink,
                      fontFamily: 'Caveat',
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 40, height: 40),
          ],
        ),
      ),
    );
  }
}
