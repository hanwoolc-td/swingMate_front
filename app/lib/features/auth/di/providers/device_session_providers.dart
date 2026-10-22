import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swingmate/features/auth/domain/entities/device_session.dart';
import 'package:swingmate/features/auth/presentation/viewmodels/device_sessions_view_model.dart';

final deviceSessionsViewModelProvider = AsyncNotifierProvider<
  DeviceSessionsViewModel,
  List<DeviceSession>
>(DeviceSessionsViewModel.new);
