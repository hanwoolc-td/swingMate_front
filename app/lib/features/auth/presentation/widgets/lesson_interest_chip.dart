import 'package:flutter/material.dart';
import 'package:swingmate/app/theme/app_colors.dart';

class LessonInterestChip extends StatelessWidget {
  const LessonInterestChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Semantics(
        button: true,
        selected: isSelected,
        label: label,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.ink : AppColors.surface,
              border: Border.all(color: AppColors.borderSubtle),
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [
                BoxShadow(color: AppColors.shadow, blurRadius: 1),
              ],
            ),
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.surface : AppColors.ink,
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
