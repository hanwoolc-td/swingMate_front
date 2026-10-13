import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:swingmate/app/theme/app_colors.dart';
import 'package:swingmate/core/theme/app_assets.dart';

class ProfileField extends StatelessWidget {
  const ProfileField({
    required this.label,
    required this.controller,
    required this.hintText,
    this.keyboardType,
    this.inputFormatters,
    this.maxLength,
    this.fillColor = AppColors.inputBackground,
    this.onChanged,
    super.key,
  });

  final String label;
  final TextEditingController controller;
  final String hintText;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final Color fillColor;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: AppColors.ink,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 4),
            SvgPicture.asset(AppAssets.requiredAsterisk),
          ],
        ),
        const SizedBox(height: 16),
        TextField(
          controller: controller,
          onChanged: onChanged,
          onTap: () => _scrollToBottom(context),
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          maxLength: maxLength,
          style: const TextStyle(color: AppColors.ink, fontSize: 16),
          decoration: InputDecoration(
            counterText: maxLength == null ? null : '',
            hintText: hintText,
            hintStyle: const TextStyle(
              color: AppColors.navigationInactive,
              fontSize: 16,
            ),
            filled: true,
            fillColor: fillColor,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.ink),
            ),
          ),
        ),
      ],
    );
  }

  void _scrollToBottom(BuildContext context) {
    Future<void>.delayed(const Duration(milliseconds: 300), () {
      if (!context.mounted) return;
      final scrollable = Scrollable.maybeOf(context);
      if (scrollable == null) return;
      scrollable.position.animateTo(
        scrollable.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    });
  }
}
