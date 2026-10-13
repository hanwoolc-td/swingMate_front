import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:swingmate/app/router/app_route_definitions.dart';
import 'package:swingmate/app/router/app_route_error_page.dart';
import 'package:swingmate/app/router/app_routes.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouterProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: AppRoutes.loginPath,
    debugLogDiagnostics: kDebugMode,
    routes: AppRouteDefinitions.routes,
    errorBuilder: (context, state) => AppRouteErrorPage(state: state),

    // 인증 기능이 추가되면 인증 Provider를 listen하고 redirect를 이곳에
    // 연결한다. 화면 정의는 인증 상태를 직접 참조하지 않는다.
  );

  ref.onDispose(router.dispose);
  return router;
});
