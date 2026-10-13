import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:swingmate/app/theme/app_colors.dart';

class RoleSelectionCard extends StatelessWidget {
  const RoleSelectionCard({
    required this.title,
    required this.description,
    required this.iconAsset,
    required this.selected,
    required this.onTap,
    this.iconHasBackground = false,
    super.key,
  });

  final String title;
  final String description;
  final String iconAsset;
  final bool selected;
  final VoidCallback onTap;
  final bool iconHasBackground;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: '$title 선택',
      child: SizedBox(
        width: double.infinity,
        height: 140,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: selected ? AppColors.roleCardBackground : AppColors.surface,
            border: Border.all(
              color: selected ? AppColors.ink : AppColors.border,
            ),
            borderRadius: BorderRadius.circular(8),
            boxShadow: const [
              BoxShadow(
                color: AppColors.shadow,
                offset: Offset(0, 2),
                blurRadius: 4,
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    _RoleIcon(
                      asset: iconAsset,
                      hasBackground: iconHasBackground,
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              color: AppColors.ink,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            description,
                            style: const TextStyle(
                              color: AppColors.secondaryText,
                              fontSize: 14,
                              height: 1.5,
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
        ),
      ),
    );
  }
}

class _RoleIcon extends StatelessWidget {
  const _RoleIcon({required this.asset, required this.hasBackground});

  final String asset;
  final bool hasBackground;

  @override
  Widget build(BuildContext context) {
    if (hasBackground) {
      return SizedBox(width: 75, height: 75, child: SvgPicture.asset(asset));
    }

    return Container(
      width: 75,
      height: 75,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: AppColors.roleCardBackground,
        shape: BoxShape.circle,
      ),
      child: SizedBox(width: 40, height: 40, child: SvgPicture.asset(asset)),
    );
  }
}
