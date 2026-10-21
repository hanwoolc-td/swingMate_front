import 'package:flutter/material.dart';

/// 앱의 원천  팔레트
/// - 실제 색상 값을 정의하는 가장 낮은 레이어 계층으로, 다른 테마 레이어에서 이 파일을 참조함
///   예) 배경색, 본문색, 버튼색, 테두리색, 그림자색
///
/// ** 주의 **
/// UI 위젯에서는 이 클래스의 정적 필드를 직접 사용하지 않고, app_theme.dart의 [AppTheme]를 통해 접근해야 합니다.
/// 앱 시작점에서 [AppTheme]를 초기화하면, 앱 전체에서 [Theme.of(context)]를 통해 접근 가능
///
/// ** 주요 기능 **
/// - 색상 팔레트 정의 : 브랜드/보조/중립 계열의 primitive 색상 상수 정의
/// - 그라데이션 : 앱에서 사용되는 주요 그라데이션 정의
///
/// ** 사용 예시 **
/// ```dart
/// // 권장 방식(테마 사용)
/// final colorScheme = Theme.of(context).colorScheme;
/// final primaryColor = colorScheme.primary;
///
/// // 지양 방식(직접 접근)
/// final inkColor = AppColors.ink;
/// ```
abstract final class AppColors {
  static const ink = Color(0xFF1A1C1E);
  static const action = Color(0xFF202428);
  static const secondaryText = Color(0xFF6E6F70);
  static const tagForeground = Color(0xFF58595B);
  static const navigationInactive = Color(0xFF9F9F9F);

  static const pageBackground = Color(0xFFF0F2F4);
  static const surface = Color(0xFFFFFFFF);
  static const border = Color(0xFFE5E6E9);
  static const borderSubtle = Color(0x80E5E6E9);
  static const controlBorder = Color(0xFFC5C5C5);
  static const dashedBorder = Color(0xFFADB0B7);

  static const lessonStatusBackground = Color(0xFFCEF2D0);
  static const lessonStatusForeground = Color(0xFF17461A);
  static const lessonPassIconBackground = Color(0xFFE5E6E9);

  static const shadow = Color(0x14000000);
  static const cardShadow = Color(0x05000000);

  static const kakao = Color(0xFFFEE500);
  static const kakaoForeground = Color(0xFF3C1E1E);
  static const apple = Color(0xFF000000);
  static const loginShadow = Color(0x1F000000);

  static const roleCardBackground = Color(0xFFF7F8F9);
  static const selectionCardBackground = Color(0xFFF4F5F8);
  static const profilePhotoBackground = Color(0xFFCBD3DA);
  static const profileBadge = Color(0xFF113E30);
  static const inputBackground = Color(0xFFF0F1F4);
  static const required = Color(0xFFE05858);
}
