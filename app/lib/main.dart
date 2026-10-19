import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:swingmate/app/app.dart';
import 'package:swingmate/core/config/app_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final config = AppConfig.fromEnvironment();
  KakaoSdk.init(nativeAppKey: config.kakaoNativeAppKey);
  await GoogleSignIn.instance.initialize(
    serverClientId: config.googleServerClientId,
  );
  runApp(const ProviderScope(child: SwingMateApp()));
}
