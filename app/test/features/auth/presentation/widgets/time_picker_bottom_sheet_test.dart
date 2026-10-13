import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:swingmate/features/auth/presentation/widgets/time_picker_bottom_sheet.dart';

void main() {
  testWidgets('shows wheel controls and returns the selected time', (
    tester,
  ) async {
    TimeOfDay? result;

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () async {
              result = await showTimePickerBottomSheet(
                context,
                initialTime: const TimeOfDay(hour: 9, minute: 5),
              );
            },
            child: const Text('시간 열기'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('시간 열기'));
    await tester.pumpAndSettle();

    expect(find.text('시간 선택'), findsOneWidget);
    expect(
      find.byKey(const ValueKey('time-picker-hour-wheel')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('time-picker-minute-wheel')),
      findsOneWidget,
    );

    await tester.tap(find.byKey(const ValueKey('time-picker-confirm')));
    await tester.pumpAndSettle();

    expect(result, const TimeOfDay(hour: 9, minute: 5));
  });
}
