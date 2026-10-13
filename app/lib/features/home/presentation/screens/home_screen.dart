import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:swingmate/app/router/app_routes.dart';
import 'package:swingmate/app/theme/app_colors.dart';
import 'package:swingmate/core/theme/app_assets.dart';
import 'package:swingmate/features/home/di/providers/home_providers.dart';
import 'package:swingmate/features/home/domain/entities/home_dashboard.dart';
import 'package:swingmate/features/home/presentation/helpers/home_formatters.dart';
import 'package:swingmate/features/home/presentation/widgets/home_bottom_navigation.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboard = ref.watch(homeDashboardProvider);

    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      body: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 393),
            child: Column(
              children: [
                const _HomeHeader(),
                Expanded(
                  child: dashboard.when(
                    loading: () => const _HomeLoading(),
                    error: (error, stackTrace) => _HomeError(
                      onRetry: () => ref.invalidate(homeDashboardProvider),
                    ),
                    data: (data) {
                      final isEmpty =
                          data.upcomingLesson == null &&
                          data.lessonPasses.isEmpty &&
                          data.recentLessons.isEmpty;
                      return isEmpty
                          ? const _EmptyDashboardContent()
                          : _DashboardContent(data: data);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const HomeBottomNavigation(),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.pageBackground,
      child: SizedBox(
        height: 56,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'SwingMate',
                style: TextStyle(
                  color: AppColors.ink,
                  fontFamily: 'Caveat',
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                ),
              ),
              _TapTarget(
                semanticLabel: '알림',
                onTap: () => context.pushNamed(AppRoutes.notificationsName),
                child: const _SvgAsset(AppAssets.homeEmptyNotifications),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyDashboardContent extends StatelessWidget {
  const _EmptyDashboardContent();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.pageBackground,
      child: RefreshIndicator(
        onRefresh: () async {
          final container = ProviderScope.containerOf(context);
          await container.refresh(homeDashboardProvider.future);
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 48),
          children: [
            _EmptyHomeSection(
              title: '다가오는 레슨',
              icon: AppAssets.homeEmptyEventBusy,
              emptyTitle: '예정된 레슨 예약이 없어요.',
              description: '레슨을 예약하면 가장 가까운 레슨이 표시돼요.',
              contentGap: 16,
              emptyIconGap: 12,
              emptyVerticalPadding: 12,
              actionLabel: '레슨 예약',
              onAction: () => _showComingSoon(context, '레슨 예약'),
            ),
            const SizedBox(height: 12),
            _EmptyHomeSection(
              title: '내 레슨권',
              icon: AppAssets.homeEmptyLessonPass,
              emptyTitle: '아직 레슨권이 없어요.',
              description: '첫 레슨권을 만들어보세요.',
              contentGap: 24,
              emptyIconGap: 8,
              actionLabel: '레슨권 추가',
              onAction: () => _showComingSoon(context, '레슨권 추가'),
              onSeeAll: () => _showComingSoon(context, '전체 레슨권'),
            ),
            const SizedBox(height: 12),
            _EmptyHomeSection(
              title: '최근 레슨 기록',
              icon: AppAssets.homeEmptyLessonRecord,
              emptyTitle: '완료한 레슨이 없어요.',
              description: '레슨을 완료하면 기록이 여기에 표시돼요.',
              contentGap: 24,
              emptyIconGap: 16,
              emptyVerticalPadding: 12,
              onSeeAll: () => _showComingSoon(context, '전체 레슨 기록'),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyHomeSection extends StatelessWidget {
  const _EmptyHomeSection({
    required this.title,
    required this.icon,
    required this.emptyTitle,
    required this.description,
    required this.contentGap,
    required this.emptyIconGap,
    this.emptyVerticalPadding = 0,
    this.actionLabel,
    this.onAction,
    this.onSeeAll,
  });

  final String title;
  final String icon;
  final String emptyTitle;
  final String description;
  final double contentGap;
  final double emptyIconGap;
  final double emptyVerticalPadding;
  final String? actionLabel;
  final VoidCallback? onAction;
  final VoidCallback? onSeeAll;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _EmptySectionHeader(title: title, onSeeAll: onSeeAll),
          SizedBox(height: contentGap),
          Padding(
            padding: EdgeInsets.symmetric(vertical: emptyVerticalPadding),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  _SvgAsset(icon),
                  SizedBox(height: emptyIconGap),
                  Text(
                    emptyTitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppColors.ink,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppColors.secondaryText,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      height: 24 / 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (actionLabel != null) ...[
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 40,
              child: FilledButton(
                onPressed: onAction,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.action,
                  foregroundColor: AppColors.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                child: Text(actionLabel!),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _EmptySectionHeader extends StatelessWidget {
  const _EmptySectionHeader({required this.title, this.onSeeAll});

  final String title;
  final VoidCallback? onSeeAll;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.ink,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        if (onSeeAll != null)
          InkWell(
            onTap: onSeeAll,
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '전체 보기',
                  style: TextStyle(
                    color: AppColors.secondaryText,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                _SvgAsset(AppAssets.homeEmptyArrowRight),
              ],
            ),
          ),
      ],
    );
  }
}

class _DashboardContent extends StatelessWidget {
  const _DashboardContent({required this.data});

  final HomeDashboard data;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.pageBackground,
      child: RefreshIndicator(
        onRefresh: () async {
          final container = ProviderScope.containerOf(context);
          await container.refresh(homeDashboardProvider.future);
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            const SizedBox(height: 16),
            _OverviewSection(data: data),
            const SizedBox(height: 16),
            _LessonPassSection(passes: data.lessonPasses),
            const SizedBox(height: 16),
            _RecentLessonSection(records: data.recentLessons),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _OverviewSection extends StatelessWidget {
  const _OverviewSection({required this.data});

  final HomeDashboard data;

  @override
  Widget build(BuildContext context) {
    return _SectionShell(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '다가오는 레슨',
              style: TextStyle(
                color: AppColors.ink,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            if (data.upcomingLesson case final lesson?)
              _UpcomingLessonCard(lesson: lesson)
            else
              const _EmptyCard(message: '예정된 레슨이 없어요'),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 42,
              child: FilledButton.icon(
                onPressed: () => _showComingSoon(context, '레슨 예약'),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.action,
                  foregroundColor: AppColors.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: const _SvgAsset(AppAssets.add),
                label: const Text(
                  '레슨 예약',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UpcomingLessonCard extends StatelessWidget {
  const _UpcomingLessonCard({required this.lesson});

  final UpcomingLesson lesson;

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      borderRadius: 12,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      child: Column(
        children: [
          Row(
            children: [
              const _CourseImage(size: 100),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: AppColors.lessonStatusBackground,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        child: Text(
                          formatLessonStatus(lesson.status),
                          style: const TextStyle(
                            color: AppColors.lessonStatusForeground,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      formatHomeDateTime(lesson.startsAt),
                      style: const TextStyle(
                        color: AppColors.ink,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _IconText(
                      icon: AppAssets.lessonTicket,
                      text:
                          '${lesson.lessonName} '
                          '(${formatSessionNumber(lesson.sessionNumber)})',
                    ),
                    const SizedBox(height: 8),
                    _IconText(icon: AppAssets.distance, text: lesson.location),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const SizedBox(
            height: 1,
            width: double.infinity,
            child: FittedBox(
              fit: BoxFit.fill,
              child: _SvgAsset(AppAssets.divider),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: _LessonAction(
                  icon: AppAssets.assignment,
                  label: '예약 상세',
                  onTap: () => _showComingSoon(context, '예약 상세'),
                ),
              ),
              const SizedBox(
                height: 32,
                child: VerticalDivider(
                  width: 17,
                  thickness: 1,
                  color: AppColors.border,
                ),
              ),
              Expanded(
                child: _LessonAction(
                  icon: AppAssets.eventRepeat,
                  label: '일정 변경',
                  onTap: () => _showComingSoon(context, '일정 변경'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LessonAction extends StatelessWidget {
  const _LessonAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final String icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            _SvgAsset(icon),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  color: AppColors.secondaryText,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const _SvgAsset(AppAssets.arrowRight),
          ],
        ),
      ),
    );
  }
}

class _LessonPassSection extends StatelessWidget {
  const _LessonPassSection({required this.passes});

  final List<LessonPass> passes;

  @override
  Widget build(BuildContext context) {
    return _ContentSection(
      title: '내 레슨권',
      onSeeAll: () => _showComingSoon(context, '전체 레슨권'),
      footer: SizedBox(
        width: double.infinity,
        height: 42,
        child: FilledButton(
          onPressed: () => _showComingSoon(context, '레슨권 추가'),
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.action,
            foregroundColor: AppColors.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            '레슨권 추가',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
      ),
      child: passes.isEmpty
          ? const _EmptyCard(message: '사용 중인 레슨권이 없어요')
          : Column(
              children: [
                for (var index = 0; index < passes.length; index++) ...[
                  _LessonPassCard(pass: passes[index]),
                  if (index != passes.length - 1)
                    const Divider(height: 1, color: AppColors.border),
                ],
              ],
            ),
    );
  }
}

class _LessonPassCard extends StatelessWidget {
  const _LessonPassCard({required this.pass});

  final LessonPass pass;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showComingSoon(context, pass.title),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: const BoxDecoration(
                color: AppColors.lessonPassIconBackground,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.golf_course,
                color: AppColors.secondaryText,
                size: 30,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pass.title,
                    style: const TextStyle(
                      color: AppColors.ink,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(child: _PassProgress(value: pass.progress)),
                      const SizedBox(width: 16),
                      Text(
                        '${pass.usedCount} / ${pass.totalCount}',
                        style: const TextStyle(
                          color: AppColors.ink,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            const _SvgAsset(AppAssets.arrowRight),
          ],
        ),
      ),
    );
  }
}

class _PassProgress extends StatelessWidget {
  const _PassProgress({required this.value});

  final double value;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        const _SvgAsset(AppAssets.progressTrack),
        if (value > 0) const _SvgAsset(AppAssets.progressValue),
      ],
    );
  }
}

class _RecentLessonSection extends StatelessWidget {
  const _RecentLessonSection({required this.records});

  final List<LessonRecord> records;

  @override
  Widget build(BuildContext context) {
    return _ContentSection(
      title: '최근 레슨 기록',
      onSeeAll: () => _showComingSoon(context, '전체 레슨 기록'),
      child: records.isEmpty
          ? const _EmptyCard(message: '최근 레슨 기록이 없어요')
          : Column(
              children: [
                for (var index = 0; index < records.length; index++) ...[
                  _LessonRecordCard(record: records[index]),
                  if (index != records.length - 1) const SizedBox(height: 12),
                ],
              ],
            ),
    );
  }
}

class _LessonRecordCard extends StatelessWidget {
  const _LessonRecordCard({required this.record});

  final LessonRecord record;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showComingSoon(context, record.title),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _CourseImage(size: 54),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            text: '${record.title} ',
                            style: const TextStyle(
                              color: AppColors.ink,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            children: [
                              TextSpan(
                                text:
                                    '(${formatSessionNumber(record.sessionNumber)})',
                                style: const TextStyle(
                                  color: AppColors.secondaryText,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const _SvgAsset(AppAssets.arrowRight),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text.rich(
                    TextSpan(
                      text: '${formatHomeDateTime(record.occurredAt)} · ',
                      style: const TextStyle(
                        color: AppColors.secondaryText,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      children: [
                        TextSpan(
                          text: formatSessionNumber(record.sessionNumber),
                          style: const TextStyle(
                            color: AppColors.secondaryText,
                          ),
                        ),
                      ],
                    ),
                    style: const TextStyle(
                      color: AppColors.secondaryText,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContentSection extends StatelessWidget {
  const _ContentSection({
    required this.title,
    required this.onSeeAll,
    required this.child,
    this.footer,
  });

  final String title;
  final VoidCallback onSeeAll;
  final Widget child;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    return _SectionShell(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.ink,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                InkWell(
                  onTap: onSeeAll,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Text(
                          '전체 보기',
                          style: TextStyle(
                            color: AppColors.secondaryText,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(width: 4),
                        _SvgAsset(AppAssets.arrowRight),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            child,
            if (footer != null) ...[const SizedBox(height: 16), footer!],
          ],
        ),
      ),
    );
  }
}

class _SectionShell extends StatelessWidget {
  const _SectionShell({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
      ),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }
}

class _CardShell extends StatelessWidget {
  const _CardShell({
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.borderRadius = 8,
  });

  final Widget child;
  final EdgeInsets padding;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.borderSubtle),
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            offset: Offset(0, 2),
            blurRadius: 2,
          ),
        ],
      ),
      child: child,
    );
  }
}

class _CourseImage extends StatelessWidget {
  const _CourseImage({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: size,
        height: size,
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            Positioned(
              left: -127,
              top: -99,
              width: 353,
              height: 235,
              child: Image.asset(AppAssets.golfCourseImage, fit: BoxFit.cover),
            ),
          ],
        ),
      ),
    );
  }
}

class _IconText extends StatelessWidget {
  const _IconText({required this.icon, required this.text});

  final String icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _SvgAsset(icon),
        const SizedBox(width: 10),
        Expanded(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              text,
              maxLines: 1,
              style: const TextStyle(
                color: AppColors.secondaryText,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                height: 1,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SvgAsset extends StatelessWidget {
  const _SvgAsset(this.path);

  final String path;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(path);
  }
}

class _TapTarget extends StatelessWidget {
  const _TapTarget({
    required this.semanticLabel,
    required this.onTap,
    required this.child,
  });

  final String semanticLabel;
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: semanticLabel,
      child: InkResponse(
        onTap: onTap,
        radius: 20,
        child: SizedBox(width: 40, height: 40, child: Center(child: child)),
      ),
    );
  }
}

class _HomeLoading extends StatelessWidget {
  const _HomeLoading();

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: AppColors.pageBackground,
      child: Center(child: CircularProgressIndicator()),
    );
  }
}

class _HomeError extends StatelessWidget {
  const _HomeError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.pageBackground,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('홈 정보를 불러오지 못했어요'),
            const SizedBox(height: 12),
            OutlinedButton(onPressed: onRetry, child: const Text('다시 시도')),
          ],
        ),
      ),
    );
  }
}

class _EmptyCard extends StatelessWidget {
  const _EmptyCard({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text(
            message,
            style: const TextStyle(color: AppColors.secondaryText),
          ),
        ),
      ),
    );
  }
}

void _showComingSoon(BuildContext context, String feature) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text('$feature 기능은 다음 단계에서 연결합니다.')));
}
