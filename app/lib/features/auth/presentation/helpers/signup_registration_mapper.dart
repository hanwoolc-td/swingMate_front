import 'package:swingmate/features/auth/domain/entities/golf_experience.dart';
import 'package:swingmate/features/auth/domain/entities/lesson_interest.dart';
import 'package:swingmate/features/auth/domain/entities/lesson_weekday.dart';
import 'package:swingmate/features/auth/domain/entities/member_registration.dart';
import 'package:swingmate/features/auth/domain/entities/pro_registration.dart';
import 'package:swingmate/features/auth/presentation/states/signup_flow_state.dart';

/// 화면에서 고른 한글 라벨과 입력값을 Domain 타입으로 바꾼다.
abstract final class SignupRegistrationMapper {
  static const _interests = {
    '초보': LessonInterest.beginner,
    '스윙 교정': LessonInterest.swingCorrection,
    '숏게임': LessonInterest.shortGame,
    '드라이버': LessonInterest.driver,
    '아이언': LessonInterest.iron,
    '퍼팅': LessonInterest.putting,
    '로프트샷': LessonInterest.lobShot,
    '스팅어샷': LessonInterest.stingerShot,
    '기타': LessonInterest.other,
  };

  static const _experiences = {
    '아직 시작 전': GolfExperience.under6Months,
    '6개월 미만': GolfExperience.under6Months,
    '6개월 ~ 1년': GolfExperience.months6To3Years,
    '1 ~ 3년': GolfExperience.months6To3Years,
    '3년 ~ 7년': GolfExperience.years3To7,
    '7년 이상': GolfExperience.over7Years,
  };

  static const _weekdays = {
    '월': LessonWeekday.monday,
    '화': LessonWeekday.tuesday,
    '수': LessonWeekday.wednesday,
    '목': LessonWeekday.thursday,
    '금': LessonWeekday.friday,
    '토': LessonWeekday.saturday,
    '일': LessonWeekday.sunday,
  };

  /// 화면에 표시되는 요일 순서.
  static const _weekdayOrder = ['월', '화', '수', '목', '금', '토', '일'];

  static MemberRegistration? member(SignupFlowState state) {
    final experience = _experiences[state.member.selectedExperience];
    if (experience == null) return null;

    return MemberRegistration(
      name: state.name,
      phoneNumber: state.phoneNumber,
      lessonInterests: {
        for (final label in state.member.selectedInterests) ?_interests[label],
      },
      golfExperience: experience,
    );
  }

  static ProRegistration pro(SignupFlowState state) {
    final pro = state.pro;
    return ProRegistration(
      name: state.name,
      phoneNumber: state.phoneNumber,
      introduction: pro.introduction,
      careers: [
        for (final career in pro.careers)
          if (career.trim().isNotEmpty) career.trim(),
      ],
      availability: [
        for (final day in _weekdayOrder)
          if (pro.selectedDays.contains(day))
            DayAvailability(
              weekday: _weekdays[day]!,
              timeRanges: [
                for (final range
                    in pro.isDaySpecific
                        ? pro.dayRanges[day] ?? const <LessonTimeRangeInput>[]
                        : pro.sharedRanges)
                  LessonTimeRange(
                    startMinutes: _minutes(range.start),
                    endMinutes: _minutes(range.end),
                  ),
              ],
            ),
      ],
    );
  }

  static int _minutes(String time) {
    final parts = time.split(':');
    return int.parse(parts[0]) * 60 + int.parse(parts[1]);
  }
}
