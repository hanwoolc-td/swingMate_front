import 'package:dio/dio.dart';
import 'package:swingmate/features/auth/data/models/device_session_model.dart';

class DeviceSessionRemoteDataSource {
  const DeviceSessionRemoteDataSource(this._dio);

  final Dio _dio;

  Future<List<DeviceSessionModel>> getSessions() async {
    final response = await _dio.get<List<dynamic>>('/api/v1/auth/sessions');
    return (response.data ?? const [])
        .whereType<Map<String, dynamic>>()
        .map(DeviceSessionModel.fromJson)
        .toList(growable: false);
  }

  Future<void> revokeSession(String id) async {
    await _dio.delete<void>('/api/v1/auth/sessions/$id');
  }

  Future<void> revokeAllSessions() async {
    await _dio.delete<void>('/api/v1/auth/sessions');
  }
}
