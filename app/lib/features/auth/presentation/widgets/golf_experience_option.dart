import 'package:flutter/material.dart';
import 'package:swingmate/app/theme/app_colors.dart';

class GolfExperienceOption extends StatelessWidget {
  const GolfExperienceOption({
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
    return Semantics(
      inMutuallyExclusiveGroup: true,
      selected: isSelected,
      label: label,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.ink : AppColors.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.controlBorder),
                ),
                child: isSelected
                    ? const Center(
                        child: Icon(
                          Icons.check,
                          size: 12,
                          color: AppColors.surface,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 16),
              Text(
                label,
                style: const TextStyle(color: AppColors.ink, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
