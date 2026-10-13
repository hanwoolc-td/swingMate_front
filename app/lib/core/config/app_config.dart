import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AppEnvironment { development, production }

class AppConfig {
  const AppConfig({required this.environment, required this.apiBaseUrl});

  factory AppConfig.fromEnvironment() {
    const environmentName = String.fromEnvironment(
      'APP_ENV',
      defaultValue: 'development',
    );
    const apiBaseUrl = String.fromEnvironment(
      'API_BASE_URL',
      defaultValue: 'http://localhost:8080',
    );

    return AppConfig(
      environment: switch (environmentName) {
        'production' => AppEnvironment.production,
        _ => AppEnvironment.development,
      },
      apiBaseUrl: apiBaseUrl,
    );
  }

  final AppEnvironment environment;
  final String apiBaseUrl;

  bool get isProduction => environment == AppEnvironment.production;

  String get environmentLabel => switch (environment) {
    AppEnvironment.development => '개발',
    AppEnvironment.production => '운영',
  };
}

final appConfigProvider = Provider<AppConfig>((ref) {
  return AppConfig.fromEnvironment();
});
