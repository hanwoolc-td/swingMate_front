import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:swingmate/app/theme/app_colors.dart';
import 'package:swingmate/core/theme/app_assets.dart';

class ProfilePhotoPlaceholder extends StatelessWidget {
  const ProfilePhotoPlaceholder({required this.onTap, super.key});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '프로필 사진 추가',
      child: InkResponse(
        onTap: onTap,
        radius: 55,
        child: SizedBox(
          width: 86.4,
          height: 104.16,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              ClipOval(
                child: Container(
                  width: 86.4,
                  height: 86.4,
                  color: AppColors.profilePhotoBackground,
                  child: Stack(
                    clipBehavior: Clip.hardEdge,
                    children: [
                      Positioned(
                        left: -40,
                        top: 8,
                        child: SvgPicture.asset(AppAssets.profilePolygon1),
                      ),
                      Positioned(
                        left: -16,
                        top: -27,
                        child: SvgPicture.asset(AppAssets.profilePolygon4),
                      ),
                      Positioned(
                        left: 0,
                        top: 48,
                        child: SvgPicture.asset(AppAssets.profilePolygon3),
                      ),
                      Positioned(
                        left: 37,
                        top: -2,
                        child: SvgPicture.asset(AppAssets.profilePolygon2),
                      ),
                      Center(
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: const BoxDecoration(
                            color: Color(0xE0FFFFFF),
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: SvgPicture.asset(AppAssets.profileCamera),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 59,
                top: 62,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: AppColors.profileBadge,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.surface, width: 1.44),
                    boxShadow: const [
                      BoxShadow(
                        color: AppColors.shadow,
                        blurRadius: 1.44,
                        offset: Offset(0, 1.44),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: SvgPicture.asset(AppAssets.profilePlus),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
