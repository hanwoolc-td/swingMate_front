import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swingmate/features/auth/di/providers/device_session_repository_provider.dart';
import 'package:swingmate/features/auth/domain/entities/device_session.dart';

class DeviceSessionsViewModel extends AsyncNotifier<List<DeviceSession>> {
  @override
  Future<List<DeviceSession>> build() =>
      ref.watch(deviceSessionRepositoryProvider).getSessions();

  Future<void> reload() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(deviceSessionRepositoryProvider).getSessions(),
    );
  }

  Future<void> revoke(String id) async {
    await ref.read(deviceSessionRepositoryProvider).revokeSession(id);
    state = await AsyncValue.guard(
      () => ref.read(deviceSessionRepositoryProvider).getSessions(),
    );
  }

  Future<void> revokeAll() async {
    await ref.read(deviceSessionRepositoryProvider).revokeAllSessions();
    state = const AsyncData([]);
  }
}
