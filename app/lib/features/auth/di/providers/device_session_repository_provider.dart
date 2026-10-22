import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swingmate/core/network/dio_provider.dart';
import 'package:swingmate/features/auth/data/datasources/device_session_remote_data_source.dart';
import 'package:swingmate/features/auth/data/repositories/device_session_repository_impl.dart';
import 'package:swingmate/features/auth/domain/repositories/device_session_repository.dart';

final deviceSessionRepositoryProvider = Provider<DeviceSessionRepository>(
  (ref) => DeviceSessionRepositoryImpl(
    DeviceSessionRemoteDataSource(ref.watch(dioProvider)),
  ),
);
