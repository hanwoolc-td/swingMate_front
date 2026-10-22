class DeviceSession {
  const DeviceSession({
    required this.id,
    required this.deviceName,
    required this.platform,
    required this.createdAt,
    required this.lastUsedAt,
    required this.isCurrent,
    this.appVersion,
  });

  final String id;
  final String deviceName;
  final String platform;
  final DateTime createdAt;
  final DateTime lastUsedAt;
  final bool isCurrent;
  final String? appVersion;
}
