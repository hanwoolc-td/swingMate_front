import 'package:swingmate/features/auth/domain/entities/golf_experience.dart';
import 'package:swingmate/features/auth/domain/entities/lesson_interest.dart';

class MemberRegistration {
  const MemberRegistration({
    required this.name,
    required this.phoneNumber,
    required this.lessonInterests,
    required this.golfExperience,
  });

  final String name;
  final String phoneNumber;
  final Set<LessonInterest> lessonInterests;
  final GolfExperience golfExperience;
}
