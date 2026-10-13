import 'package:swingmate/features/home/domain/entities/home_dashboard.dart';

String formatHomeDateTime(DateTime value) {
  const weekdays = ['월', '화', '수', '목', '금', '토', '일'];
  final hour = value.hour.toString().padLeft(2, '0');
  final minute = value.minute.toString().padLeft(2, '0');

  return '${value.month}월 ${value.day}일 '
      '(${weekdays[value.weekday - 1]}) $hour:$minute';
}

String formatSessionNumber(int value) => '$value회차';

String formatLessonStatus(LessonStatus status) {
  return switch (status) {
    LessonStatus.confirmed => '예약 확정',
  };
}
