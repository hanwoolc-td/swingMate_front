import 'package:swingmate/features/auth/domain/entities/device_session.dart';

class DeviceSessionModel {
  const DeviceSessionModel(this.entity);

  factory DeviceSessionModel.fromJson(Map<String, dynamic> json) {
    return DeviceSessionModel(
      DeviceSession(
        id: json['id'] as String,
        deviceName: json['deviceName'] as String? ?? '알 수 없는 기기',
        platform: json['platform'] as String? ?? 'UNKNOWN',
        appVersion: json['appVersion'] as String?,
        createdAt: DateTime.parse(json['createdAt'] as String),
        lastUsedAt: DateTime.parse(json['lastUsedAt'] as String),
        isCurrent: json['current'] == true,
      ),
    );
  }

  final DeviceSession entity;
}
