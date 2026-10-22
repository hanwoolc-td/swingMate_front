import 'package:swingmate/features/auth/domain/entities/device_session.dart';

abstract interface class DeviceSessionRepository {
  Future<List<DeviceSession>> getSessions();
  Future<void> revokeSession(String id);
  Future<void> revokeAllSessions();
}
