import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:swingmate/app/theme/app_colors.dart';

class SocialLoginButton extends StatelessWidget {
  const SocialLoginButton({
    required this.label,
    required this.iconAsset,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.onPressed,
    this.iconSize = 20,
    this.iconLeft = 20,
    this.iconIsSvg = false,
    this.borderColor,
    this.shadowBlurRadius = 4,
    this.fontWeight = FontWeight.w700,
    super.key,
  });

  final String label;
  final String iconAsset;
  final Color backgroundColor;
  final Color foregroundColor;
  final VoidCallback onPressed;
  final double iconSize;
  final double iconLeft;
  final bool iconIsSvg;
  final Color? borderColor;
  final double shadowBlurRadius;
  final FontWeight fontWeight;

  @override
  Widget build(BuildContext context) {
    const radius = BorderRadius.all(Radius.circular(12));

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: backgroundColor,
          border: borderColor == null ? null : Border.all(color: borderColor!),
          borderRadius: radius,
          boxShadow: [
            BoxShadow(
              color: AppColors.loginShadow,
              offset: const Offset(0, 2),
              blurRadius: shadowBlurRadius,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: radius,
          child: InkWell(
            onTap: onPressed,
            borderRadius: radius,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: foregroundColor,
                    fontSize: 16,
                    fontWeight: fontWeight,
                    height: 1.5,
                  ),
                ),
                Positioned(
                  left: iconLeft,
                  child: SizedBox.square(
                    dimension: iconSize,
                    child: iconIsSvg
                        ? SvgPicture.asset(iconAsset)
                        : Image.asset(iconAsset, fit: BoxFit.contain),
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
