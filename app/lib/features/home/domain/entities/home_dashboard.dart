class HomeDashboard {
  const HomeDashboard({
    required this.memberName,
    required this.lessonPasses,
    required this.recentLessons,
    this.upcomingLesson,
  });

  final String memberName;
  final UpcomingLesson? upcomingLesson;
  final List<LessonPass> lessonPasses;
  final List<LessonRecord> recentLessons;
}

class UpcomingLesson {
  const UpcomingLesson({
    required this.startsAt,
    required this.lessonName,
    required this.sessionNumber,
    required this.location,
    required this.status,
  });

  final DateTime startsAt;
  final String lessonName;
  final int sessionNumber;
  final String location;
  final LessonStatus status;
}

enum LessonStatus { confirmed }

class LessonPass {
  const LessonPass({
    required this.title,
    required this.expiresAt,
    required this.usedCount,
    required this.totalCount,
  });

  final String title;
  final DateTime? expiresAt;
  final int usedCount;
  final int totalCount;

  int get remainingCount => totalCount - usedCount;
  double get progress => totalCount == 0 ? 0 : usedCount / totalCount;
}

class LessonRecord {
  const LessonRecord({
    required this.title,
    required this.sessionNumber,
    required this.occurredAt,
    required this.hasJournal,
    required this.hasVideo,
  });

  final String title;
  final int sessionNumber;
  final DateTime occurredAt;
  final bool hasJournal;
  final bool hasVideo;
}
