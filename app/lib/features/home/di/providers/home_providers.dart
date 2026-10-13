import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swingmate/features/home/data/repositories/fake_home_repository.dart';
import 'package:swingmate/features/home/domain/entities/home_dashboard.dart';
import 'package:swingmate/features/home/domain/repositories/home_repository.dart';

final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  return const FakeHomeRepository();
});

final homeDashboardProvider = FutureProvider<HomeDashboard>((ref) {
  return ref.watch(homeRepositoryProvider).fetchDashboard();
});
