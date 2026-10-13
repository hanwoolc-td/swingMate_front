import 'package:swingmate/features/home/domain/entities/home_dashboard.dart';

abstract interface class HomeRepository {
  Future<HomeDashboard> fetchDashboard();
}
