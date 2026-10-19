import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:swingmate/app/app.dart';
import 'package:swingmate/core/config/app_config.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  KakaoSdk.init(nativeAppKey: AppConfig.fromEnvironment().kakaoNativeAppKey);
  runApp(const ProviderScope(child: SwingMateApp()));
}
