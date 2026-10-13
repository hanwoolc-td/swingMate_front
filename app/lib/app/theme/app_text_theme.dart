import 'package:flutter/material.dart';

import 'app_colors.dart';

/// 앱에서 사용할 텍스트 스타일 정의
/// - 글자 크기, 굵기, 색상 등을 관리

abstract final class AppTextTheme {
  static const light = TextTheme(
    titleLarge: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w700,
      color: AppColors.ink,
    ),
    titleMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w700,
      color: AppColors.ink,
    ),
    bodyLarge: TextStyle(fontSize: 16, color: AppColors.ink),
    bodyMedium: TextStyle(fontSize: 14, color: AppColors.secondaryText),
    labelLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
    labelMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
  );
}
