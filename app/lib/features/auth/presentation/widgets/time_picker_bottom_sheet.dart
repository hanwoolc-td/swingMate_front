import 'package:flutter/material.dart';
import 'package:swingmate/app/theme/app_colors.dart';

Future<TimeOfDay?> showTimePickerBottomSheet(
  BuildContext context, {
  required TimeOfDay initialTime,
}) {
  return showModalBottomSheet<TimeOfDay>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: AppColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) => _TimePickerSheet(initialTime: initialTime),
  );
}

class _TimePickerSheet extends StatefulWidget {
  const _TimePickerSheet({required this.initialTime});

  final TimeOfDay initialTime;

  @override
  State<_TimePickerSheet> createState() => _TimePickerSheetState();
}

class _TimePickerSheetState extends State<_TimePickerSheet> {
  late final FixedExtentScrollController _hourController;
  late final FixedExtentScrollController _minuteController;
  late int _selectedHour;
  late int _selectedMinute;

  @override
  void initState() {
    super.initState();
    _selectedHour = widget.initialTime.hour;
    _selectedMinute = widget.initialTime.minute;
    _hourController = FixedExtentScrollController(initialItem: _selectedHour);
    _minuteController = FixedExtentScrollController(
      initialItem: _selectedMinute,
    );
  }

  @override
  void dispose() {
    _hourController.dispose();
    _minuteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '시간 선택',
              style: TextStyle(
                color: AppColors.ink,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Row(
            children: [
              Expanded(child: Center(child: _WheelLabel('시'))),
              SizedBox(width: 32),
              Expanded(child: Center(child: _WheelLabel('분'))),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 168,
            child: Stack(
              alignment: Alignment.center,
              children: [
                IgnorePointer(
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.roleCardBackground,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: _TimeWheel(
                        key: const ValueKey('time-picker-hour-wheel'),
                        controller: _hourController,
                        itemCount: 24,
                        selectedValue: _selectedHour,
                        onSelected: (value) {
                          setState(() => _selectedHour = value);
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 32,
                      child: Center(
                        child: Text(
                          ':',
                          style: TextStyle(
                            color: AppColors.ink,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: _TimeWheel(
                        key: const ValueKey('time-picker-minute-wheel'),
                        controller: _minuteController,
                        itemCount: 60,
                        selectedValue: _selectedMinute,
                        onSelected: (value) {
                          setState(() => _selectedMinute = value);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.ink,
                    side: const BorderSide(color: AppColors.border),
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('취소'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  key: const ValueKey('time-picker-confirm'),
                  onPressed: () => Navigator.of(context).pop(
                    TimeOfDay(hour: _selectedHour, minute: _selectedMinute),
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.action,
                    foregroundColor: AppColors.surface,
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('완료'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WheelLabel extends StatelessWidget {
  const _WheelLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(color: AppColors.secondaryText, fontSize: 14),
    );
  }
}

class _TimeWheel extends StatelessWidget {
  const _TimeWheel({
    required this.controller,
    required this.itemCount,
    required this.selectedValue,
    required this.onSelected,
    super.key,
  });

  final FixedExtentScrollController controller;
  final int itemCount;
  final int selectedValue;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return ListWheelScrollView.useDelegate(
      controller: controller,
      itemExtent: 48,
      diameterRatio: 1.5,
      perspective: 0.003,
      physics: const FixedExtentScrollPhysics(),
      onSelectedItemChanged: onSelected,
      childDelegate: ListWheelChildBuilderDelegate(
        childCount: itemCount,
        builder: (context, index) => Center(
          child: Text(
            index.toString().padLeft(2, '0'),
            style: TextStyle(
              color: index == selectedValue
                  ? AppColors.ink
                  : AppColors.navigationInactive,
              fontSize: index == selectedValue ? 22 : 18,
              fontWeight: index == selectedValue
                  ? FontWeight.w700
                  : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
