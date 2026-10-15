import 'package:swingmate/features/auth/domain/entities/lesson_weekday.dart';

/// 하루 중 시각은 0시부터의 분(0~1439)으로 보관한다.
class LessonTimeRange {
  const LessonTimeRange({required this.startMinutes, required this.endMinutes});

  final int startMinutes;
  final int endMinutes;
}

class DayAvailability {
  const DayAvailability({required this.weekday, required this.timeRanges});

  final LessonWeekday weekday;
  final List<LessonTimeRange> timeRanges;
}

class ProRegistration {
  const ProRegistration({
    required this.name,
    required this.phoneNumber,
    required this.introduction,
    required this.careers,
    required this.availability,
  });

  final String name;
  final String phoneNumber;
  final String introduction;
  final List<String> careers;
  final List<DayAvailability> availability;
}
