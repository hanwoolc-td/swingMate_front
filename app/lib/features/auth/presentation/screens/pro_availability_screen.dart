import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:swingmate/app/router/app_routes.dart';
import 'package:swingmate/app/theme/app_colors.dart';
import 'package:swingmate/core/theme/app_assets.dart';
import 'package:swingmate/features/auth/di/providers/signup_flow_providers.dart';
import 'package:swingmate/features/auth/presentation/helpers/signup_messages.dart';
import 'package:swingmate/features/auth/presentation/states/signup_flow_state.dart';
import 'package:swingmate/features/auth/presentation/widgets/onboarding_header.dart';
import 'package:swingmate/features/auth/presentation/widgets/time_picker_bottom_sheet.dart';

class ProAvailabilityScreen extends ConsumerStatefulWidget {
  const ProAvailabilityScreen({super.key});

  @override
  ConsumerState<ProAvailabilityScreen> createState() =>
      _ProAvailabilityScreenState();
}

class _ProAvailabilityScreenState extends ConsumerState<ProAvailabilityScreen> {
  static const _weekdays = ['월', '화', '수', '목', '금', '토', '일'];
  final _selectedDays = <String>{};
  final _sharedRanges = <_TimeRange>[];
  late final Map<String, List<_TimeRange>> _dayRanges;
  bool _isDaySpecific = false;
  String? _expandedDay;

  @override
  void initState() {
    super.initState();
    final draft = ref.read(signupFlowViewModelProvider).pro;
    _selectedDays.addAll(draft.selectedDays);
    _sharedRanges.addAll(draft.sharedRanges.map(_TimeRange.fromValue));
    _dayRanges = {
      for (final day in _weekdays)
        day: (draft.dayRanges[day] ?? const <LessonTimeRangeInput>[])
            .map(_TimeRange.fromValue)
            .toList(),
    };
    _isDaySpecific = draft.isDaySpecific;
    _expandedDay = null;
  }

  @override
  void dispose() {
    for (final range in _sharedRanges) {
      range.dispose();
    }
    for (final ranges in _dayRanges.values) {
      for (final range in ranges) {
        range.dispose();
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 393),
            child: Column(
              children: [
                OnboardingHeader(onBack: _goBack),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '예약 가능한 시간을\n설정해보세요.',
                          style: TextStyle(
                            color: AppColors.ink,
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            height: 36 / 24,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          '레슨 가능 요일과 시간을 설정하세요.',
                          style: TextStyle(
                            color: AppColors.secondaryText,
                            fontSize: 18,
                            height: 28 / 18,
                          ),
                        ),
                        const SizedBox(height: 48),
                        _DaySelector(
                          selectedDays: _selectedDays,
                          onTap: _toggleDay,
                        ),
                        const SizedBox(height: 32),
                        if (_isDaySpecific)
                          _DaySpecificSchedule(
                            selectedDays: _selectedDays,
                            ranges: _dayRanges,
                            onAddRange: _addDayRange,
                            onRemoveRange: _removeDayRange,
                            onRangeChanged: _syncAvailabilityState,
                            expandedDay: _expandedDay,
                            onToggleDay: _toggleExpandedDay,
                          )
                        else
                          _SharedSchedule(
                            selectedDays: _selectedDays,
                            ranges: _sharedRanges,
                            onAddRange: _addSharedRange,
                            onRemoveRange: _removeSharedRange,
                            onRangeChanged: _syncAvailabilityState,
                          ),
                        const SizedBox(height: 16),
                        Center(
                          child: TextButton(
                            onPressed: _toggleScheduleMode,
                            style: TextButton.styleFrom(
                              foregroundColor: AppColors.secondaryText,
                              textStyle: const TextStyle(fontSize: 14),
                            ),
                            child: Text(
                              _isDaySpecific
                                  ? '모든 요일에 같은 시간 적용하기'
                                  : '요일별로 다르게 설정하기',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(21.5, 0, 21.5, 24),
                  child: SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: FilledButton(
                      onPressed: _selectedDays.isEmpty ? null : _continue,
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.action,
                        disabledBackgroundColor: AppColors.border,
                        foregroundColor: AppColors.surface,
                        disabledForegroundColor: AppColors.navigationInactive,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      child: const Text('다음'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _toggleDay(String day) {
    setState(() {
      if (!_selectedDays.add(day)) {
        _selectedDays.remove(day);
        if (_expandedDay == day) {
          _expandedDay = null;
        }
      }
    });
    _syncAvailabilityState();
  }

  void _addSharedRange() {
    setState(() => _sharedRanges.add(_TimeRange(start: '', end: '')));
    _syncAvailabilityState();
  }

  void _removeSharedRange(_TimeRange range) {
    if (_sharedRanges.length == 1) return;
    setState(() {
      _sharedRanges.remove(range);
      range.dispose();
    });
    _syncAvailabilityState();
  }

  void _addDayRange(String day) {
    setState(() => _dayRanges[day]!.add(_TimeRange(start: '', end: '')));
    _syncAvailabilityState();
  }

  void _removeDayRange(String day, _TimeRange range) {
    final ranges = _dayRanges[day]!;
    if (ranges.length == 1) return;
    setState(() {
      ranges.remove(range);
      range.dispose();
    });
    _syncAvailabilityState();
  }

  void _toggleScheduleMode() {
    setState(() {
      _isDaySpecific = !_isDaySpecific;
      _expandedDay = null;
    });
    _syncAvailabilityState();
  }

  void _toggleExpandedDay(String day) {
    setState(() => _expandedDay = _expandedDay == day ? null : day);
  }

  void _syncAvailabilityState() {
    ref
        .read(signupFlowViewModelProvider.notifier)
        .updateProAvailability(
          selectedDays: _selectedDays,
          sharedRanges: _sharedRanges.map((range) => range.value).toList(),
          dayRanges: {
            for (final entry in _dayRanges.entries)
              entry.key: entry.value.map((range) => range.value).toList(),
          },
          isDaySpecific: _isDaySpecific,
        );
  }

  void _goBack() {
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.goNamed(AppRoutes.proCareerName);
  }

  Future<void> _continue() async {
    _syncAvailabilityState();
    final validationError = ref
        .read(signupFlowViewModelProvider.notifier)
        .validateProAvailability();
    if (validationError != null) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(validationError.message)));
      return;
    }
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    final isCompleted = await ref
        .read(signupFlowViewModelProvider.notifier)
        .completeProSignup();
    if (!mounted) return;

    if (!isCompleted) {
      final failure = ref.read(signupFlowViewModelProvider).submissionFailure;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(failure?.message ?? SubmissionFailure.unknown.message),
        ),
      );
      return;
    }
    context.goNamed(AppRoutes.homeName);
  }
}

class _DaySelector extends StatelessWidget {
  const _DaySelector({required this.selectedDays, required this.onTap});

  final Set<String> selectedDays;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    const days = ['월', '화', '수', '목', '금', '토', '일'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '레슨 가능 요일',
          style: TextStyle(
            color: AppColors.ink,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            for (final day in days) ...[
              if (day != days.first) const SizedBox(width: 4),
              Expanded(
                child: Semantics(
                  button: true,
                  selected: selectedDays.contains(day),
                  label: '$day요일 선택',
                  child: InkWell(
                    onTap: () => onTap(day),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      height: 42,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: selectedDays.contains(day)
                            ? AppColors.ink
                            : AppColors.surface,
                        border: Border.all(color: AppColors.border),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: const [
                          BoxShadow(color: AppColors.shadow, blurRadius: 1),
                        ],
                      ),
                      child: Text(
                        day,
                        style: TextStyle(
                          color: selectedDays.contains(day)
                              ? AppColors.surface
                              : AppColors.ink,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

class _SharedSchedule extends StatelessWidget {
  const _SharedSchedule({
    required this.selectedDays,
    required this.ranges,
    required this.onAddRange,
    required this.onRemoveRange,
    required this.onRangeChanged,
  });

  final Set<String> selectedDays;
  final List<_TimeRange> ranges;
  final VoidCallback onAddRange;
  final ValueChanged<_TimeRange> onRemoveRange;
  final VoidCallback onRangeChanged;

  @override
  Widget build(BuildContext context) {
    final selectedDayLabel = _dayLabel(selectedDays);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              '레슨 가능 시간',
              style: TextStyle(
                color: AppColors.ink,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                selectedDayLabel,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  color: AppColors.secondaryText,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const _TimeLabels(fontSize: 14),
        const SizedBox(height: 12),
        for (final range in ranges) ...[
          _TimeRangeRow(
            range: range,
            onRemove: () => onRemoveRange(range),
            onChanged: onRangeChanged,
          ),
          const SizedBox(height: 8),
        ],
        _DashedAddButton(height: 38, onTap: onAddRange),
      ],
    );
  }
}

class _DaySpecificSchedule extends StatelessWidget {
  const _DaySpecificSchedule({
    required this.selectedDays,
    required this.ranges,
    required this.onAddRange,
    required this.onRemoveRange,
    required this.onRangeChanged,
    required this.expandedDay,
    required this.onToggleDay,
  });

  final Set<String> selectedDays;
  final Map<String, List<_TimeRange>> ranges;
  final ValueChanged<String> onAddRange;
  final void Function(String, _TimeRange) onRemoveRange;
  final VoidCallback onRangeChanged;
  final String? expandedDay;
  final ValueChanged<String> onToggleDay;

  @override
  Widget build(BuildContext context) {
    const weekdayNames = {
      '월': '월요일',
      '화': '화요일',
      '수': '수요일',
      '목': '목요일',
      '금': '금요일',
      '토': '토요일',
      '일': '일요일',
    };
    const order = ['월', '화', '수', '목', '금', '토', '일'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '레슨 가능 시간',
          style: TextStyle(
            color: AppColors.ink,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 16),
        for (final day in order.where(selectedDays.contains)) ...[
          _DayScheduleCard(
            dayName: weekdayNames[day]!,
            ranges: ranges[day]!,
            isExpanded: expandedDay == day,
            onToggle: () => onToggleDay(day),
            onAddRange: () => onAddRange(day),
            onRemoveRange: (range) => onRemoveRange(day, range),
            onRangeChanged: onRangeChanged,
          ),
          const SizedBox(height: 8),
        ],
      ],
    );
  }
}

class _DayScheduleCard extends StatelessWidget {
  const _DayScheduleCard({
    required this.dayName,
    required this.ranges,
    required this.isExpanded,
    required this.onToggle,
    required this.onAddRange,
    required this.onRemoveRange,
    required this.onRangeChanged,
  });

  final String dayName;
  final List<_TimeRange> ranges;
  final bool isExpanded;
  final VoidCallback onToggle;
  final VoidCallback onAddRange;
  final ValueChanged<_TimeRange> onRemoveRange;
  final VoidCallback onRangeChanged;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            offset: Offset(0, 2),
            blurRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            button: true,
            expanded: isExpanded,
            child: InkWell(
              onTap: onToggle,
              borderRadius: BorderRadius.circular(8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dayName,
                    style: const TextStyle(
                      color: AppColors.ink,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      height: 18 / 14,
                    ),
                  ),
                  const Spacer(),
                  if (!isExpanded)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        for (final range in ranges)
                          if (range.startController.text.isNotEmpty &&
                              range.endController.text.isNotEmpty)
                            Text(
                              '${range.startController.text} ~ ${range.endController.text}',
                              style: const TextStyle(
                                color: AppColors.secondaryText,
                                fontSize: 14,
                              ),
                            ),
                      ],
                    ),
                  const SizedBox(width: 12),
                  SvgPicture.asset(AppAssets.keyboardArrowDown),
                ],
              ),
            ),
          ),
          if (isExpanded) ...[
            const SizedBox(height: 16),
            const _TimeLabels(fontSize: 12),
            const SizedBox(height: 8),
            for (final range in ranges) ...[
              _TimeRangeRow(
                range: range,
                compact: true,
                onRemove: () => onRemoveRange(range),
                onChanged: onRangeChanged,
              ),
              const SizedBox(height: 8),
            ],
            Padding(
              padding: const EdgeInsets.only(right: 36),
              child: _DashedAddButton(
                height: 30,
                compact: true,
                onTap: onAddRange,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _TimeLabels extends StatelessWidget {
  const _TimeLabels({required this.fontSize});
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            '시작 시간',
            style: TextStyle(
              color: AppColors.secondaryText,
              fontSize: fontSize,
            ),
          ),
        ),
        const SizedBox(width: 26),
        Expanded(
          child: Text(
            '종료 시간',
            style: TextStyle(
              color: AppColors.secondaryText,
              fontSize: fontSize,
            ),
          ),
        ),
        const SizedBox(width: 36),
      ],
    );
  }
}

class _TimeRangeRow extends StatelessWidget {
  const _TimeRangeRow({
    required this.range,
    required this.onRemove,
    required this.onChanged,
    this.compact = false,
  });

  final _TimeRange range;
  final VoidCallback onRemove;
  final VoidCallback onChanged;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final height = compact ? 32.0 : 40.0;
    final fontSize = compact ? 14.0 : 16.0;
    return Row(
      children: [
        Expanded(
          child: _TimeInput(
            controller: range.startController,
            height: height,
            fontSize: fontSize,
            onChanged: onChanged,
          ),
        ),
        const SizedBox(width: 8),
        const SizedBox(
          width: 10,
          child: Center(
            child: Text(
              '~',
              style: TextStyle(
                color: AppColors.navigationInactive,
                fontSize: 14,
                height: 1,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _TimeInput(
            controller: range.endController,
            height: height,
            fontSize: fontSize,
            onChanged: onChanged,
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 28.284,
          height: 28.284,
          child: InkWell(
            onTap: onRemove,
            borderRadius: BorderRadius.circular(14.142),
            child: Center(
              child: Transform.rotate(
                angle: -math.pi / 4,
                child: SvgPicture.asset(AppAssets.scheduleRemove),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _TimeInput extends StatelessWidget {
  const _TimeInput({
    required this.controller,
    required this.height,
    required this.fontSize,
    required this.onChanged,
  });
  final TextEditingController controller;
  final double height;
  final double fontSize;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: () => _selectTime(context),
          borderRadius: BorderRadius.circular(8),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.roleCardBackground,
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: ValueListenableBuilder<TextEditingValue>(
                  valueListenable: controller,
                  builder: (context, value, _) => Text(
                    value.text,
                    style: TextStyle(color: AppColors.ink, fontSize: fontSize),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectTime(BuildContext context) async {
    final selectedTime = await showTimePickerBottomSheet(
      context,
      initialTime: _parseTime(controller.text),
    );

    if (selectedTime == null) return;
    controller.text = _formatTime(selectedTime);
    onChanged();
  }
}

TimeOfDay _parseTime(String value) {
  final values = value.split(':');
  if (values.length != 2) return TimeOfDay.now();

  final hour = int.tryParse(values[0]);
  final minute = int.tryParse(values[1]);
  if (hour == null || minute == null || hour > 23 || minute > 59) {
    return TimeOfDay.now();
  }

  return TimeOfDay(hour: hour, minute: minute);
}

String _formatTime(TimeOfDay time) {
  final hour = time.hour.toString().padLeft(2, '0');
  final minute = time.minute.toString().padLeft(2, '0');
  return '$hour:$minute';
}

class _DashedAddButton extends StatelessWidget {
  const _DashedAddButton({
    required this.height,
    required this.onTap,
    this.compact = false,
  });
  final double height;
  final VoidCallback onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: compact ? double.infinity : 309,
      height: height,
      child: Semantics(
        button: true,
        label: '시간대 추가',
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(compact ? 8 : 12),
          child: CustomPaint(
            foregroundPainter: _ScheduleDashedBorderPainter(
              radius: compact ? 8 : 12,
            ),
            child: Center(
              child: SvgPicture.asset(
                AppAssets.careerAdd,
                width: compact ? 16 : 20,
                height: compact ? 16 : 20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ScheduleDashedBorderPainter extends CustomPainter {
  const _ScheduleDashedBorderPainter({required this.radius});
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(Offset.zero & size, Radius.circular(radius)),
      );
    final metric = path.computeMetrics().single;
    final paint = Paint()
      ..color = AppColors.dashedBorder
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    for (var distance = 0.0; distance < metric.length; distance += 9) {
      canvas.drawPath(metric.extractPath(distance, distance + 5), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _TimeRange {
  _TimeRange({required String start, required String end})
    : startController = TextEditingController(text: start),
      endController = TextEditingController(text: end);

  factory _TimeRange.fromValue(LessonTimeRangeInput value) {
    return _TimeRange(start: value.start, end: value.end);
  }

  final TextEditingController startController;
  final TextEditingController endController;

  LessonTimeRangeInput get value => LessonTimeRangeInput(
    start: startController.text,
    end: endController.text,
  );

  void dispose() {
    startController.dispose();
    endController.dispose();
  }
}

String _dayLabel(Set<String> days) {
  const weekdayDays = {'월', '화', '수', '목', '금'};
  if (days.length == 5 && days.containsAll(weekdayDays)) {
    return '월 · 화 · 수 · 목 · 금';
  }
  if (days.isEmpty) return '요일을 선택하세요';
  return days.join(' · ');
}
