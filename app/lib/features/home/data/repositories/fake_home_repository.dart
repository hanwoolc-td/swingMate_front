import 'package:swingmate/features/home/domain/entities/home_dashboard.dart';
import 'package:swingmate/features/home/domain/repositories/home_repository.dart';

class FakeHomeRepository implements HomeRepository {
  const FakeHomeRepository();

  @override
  Future<HomeDashboard> fetchDashboard() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));

    return HomeDashboard(
      memberName: '백진규',
      lessonPasses: const [],
      recentLessons: const [],
    );
  }
}
