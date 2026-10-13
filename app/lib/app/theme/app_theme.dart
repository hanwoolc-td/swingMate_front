import 'package:flutter/material.dart';

import 'app_color_schemes.dart';
import 'app_colors.dart';
import 'app_text_theme.dart';

/// 테마 폴더의 다른 파일들을 조합해서 최종 [ThemeData]를 생성하는 역할
/// - 앱 시작점에서 [AppTheme]를 초기화하면, 앱 전체에서 [Theme.of(context)]를 통해 접근 가능
/// - AppBar, Card, Button, Divider 등의 공통 스타일도 여기서 설정

abstract final class AppTheme {
  static ThemeData get light {
    return ThemeData(
      colorScheme: AppColorSchemes.light,
      textTheme: AppTextTheme.light,
      fontFamily: 'Inter',
      scaffoldBackgroundColor: AppColors.pageBackground,
      useMaterial3: true,
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        backgroundColor: AppColors.pageBackground,
        foregroundColor: AppColors.ink,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: const CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.action,
          foregroundColor: AppColors.surface,
          textStyle: AppTextTheme.light.labelLarge,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: 1,
        space: 1,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
      ),
    );
  }
}
