import 'package:swingmate/features/auth/data/datasources/device_session_remote_data_source.dart';
import 'package:swingmate/features/auth/domain/entities/device_session.dart';
import 'package:swingmate/features/auth/domain/repositories/device_session_repository.dart';

class DeviceSessionRepositoryImpl implements DeviceSessionRepository {
  const DeviceSessionRepositoryImpl(this._dataSource);

  final DeviceSessionRemoteDataSource _dataSource;

  @override
  Future<List<DeviceSession>> getSessions() async =>
      (await _dataSource.getSessions()).map((model) => model.entity).toList();

  @override
  Future<void> revokeSession(String id) => _dataSource.revokeSession(id);

  @override
  Future<void> revokeAllSessions() => _dataSource.revokeAllSessions();
}
