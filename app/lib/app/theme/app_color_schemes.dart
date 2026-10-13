import 'package:flutter/material.dart';

import 'app_colors.dart';

/// AppColors의 원천 색상을 Material 3의 의미 기반 색상으로 연결
/// [의미 기반 색상] : 색상 자체의 이름이 아니라, UI에서 맡은 역할을 기준으로 이름 붙인 색상
/// 예)
///   primary: 주요 액션에 사용하는 색상
///   onPrimary: primary 위에 표시되는 텍스트·아이콘 색상
///   surface: 카드, 패널, 화면 표면의 색상
///   onSurface: surface 위의 텍스트·아이콘 색상
///   outline: 입력창, 테두리, 구분선 색상
///   error: 오류 상태 색상

/// Light 모드
abstract final class AppColorSchemes {
  static const light = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.action,
    onPrimary: AppColors.surface,
    secondary: AppColors.secondaryText,
    onSecondary: AppColors.surface,
    error: Color(0xFFB3261E),
    onError: AppColors.surface,
    surface: AppColors.surface,
    onSurface: AppColors.ink,
    surfaceContainerHighest: AppColors.pageBackground,
    onSurfaceVariant: AppColors.secondaryText,
    outline: AppColors.border,
    outlineVariant: AppColors.borderSubtle,
    shadow: AppColors.shadow,
  );
}
