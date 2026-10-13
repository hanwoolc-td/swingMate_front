import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:swingmate/features/auth/di/providers/auth_providers.dart';
import 'package:swingmate/features/auth/di/providers/signup_flow_providers.dart';
import 'package:swingmate/features/auth/domain/entities/verification_code_delivery.dart';
import 'package:swingmate/features/auth/domain/repositories/auth_repository.dart';
import 'package:swingmate/features/auth/presentation/helpers/signup_messages.dart';
import 'package:swingmate/features/auth/presentation/states/signup_flow_state.dart';

void main() {
  group('SignupFlowViewModel', () {
    test('reset clears data from a previous signup attempt', () {
      final container = _createContainer(_FakeAuthRepository());
      addTearDown(container.dispose);
      final viewModel = container.read(signupFlowViewModelProvider.notifier);

      viewModel
        ..selectRole(SignupRole.member)
        ..updateName('홍길동')
        ..updatePhoneNumber('01012345678')
        ..toggleInterest('드라이버')
        ..reset();

      expect(
        container.read(signupFlowViewModelProvider),
        const SignupFlowState(),
      );
    });

    test('stores pro career and availability across screens', () {
      final container = _createContainer(_FakeAuthRepository());
      addTearDown(container.dispose);
      final viewModel = container.read(signupFlowViewModelProvider.notifier);

      viewModel
        ..selectRole(SignupRole.pro)
        ..updateProIntroduction('KPGA 프로입니다.')
        ..updateProCareer(0, 'KPGA 투어 프로')
        ..updateProAvailability(
          selectedDays: {'월', '수'},
          sharedRanges: const [
            LessonTimeRangeInput(start: '10:00', end: '18:00'),
          ],
          dayRanges: const {
            '월': [LessonTimeRangeInput(start: '10:00', end: '18:00')],
            '수': [LessonTimeRangeInput(start: '11:00', end: '17:00')],
          },
          isDaySpecific: true,
        );

      final state = container.read(signupFlowViewModelProvider);
      expect(state.role, SignupRole.pro);
      expect(state.pro.introduction, 'KPGA 프로입니다.');
      expect(state.pro.careers, ['KPGA 투어 프로']);
      expect(state.pro.selectedDays, {'월', '수'});
      expect(state.pro.isDaySpecific, isTrue);
      expect(viewModel.validateProCareer(), isEmpty);
      expect(viewModel.validateProAvailability(), isNull);
    });

    test('blocks duplicate verification-code requests', () async {
      final repository = _FakeAuthRepository(
        sendCompleter: Completer<VerificationCodeDelivery>(),
      );
      final container = _createContainer(repository);
      addTearDown(container.dispose);
      final viewModel = container.read(signupFlowViewModelProvider.notifier)
        ..updatePhoneNumber('01012345678');

      final firstRequest = viewModel.sendVerificationCode();
      expect(
        container.read(signupFlowViewModelProvider).verificationAction,
        VerificationAction.sending,
      );

      expect(await viewModel.sendVerificationCode(), isNull);
      expect(repository.sendCallCount, 1);

      repository.sendCompleter!.complete(
        const VerificationCodeDelivery(testCode: '123456'),
      );
      expect(await firstRequest, isNotNull);
      expect(
        container.read(signupFlowViewModelProvider).verificationAction,
        VerificationAction.idle,
      );
    });

    test('returns typed validation errors instead of display strings', () {
      final container = _createContainer(_FakeAuthRepository());
      addTearDown(container.dispose);
      final viewModel = container.read(signupFlowViewModelProvider.notifier);

      expect(viewModel.validateProfile(), SignupValidationError.nameRequired);
      viewModel
        ..updateName('홍길동')
        ..updatePhoneNumber('01012345678');
      expect(viewModel.validateProfile(), isNull);
      expect(
        viewModel.validateLessonPreferences(),
        SignupValidationError.interestsRequired,
      );
    });
  });
}

ProviderContainer _createContainer(AuthRepository repository) {
  return ProviderContainer(
    overrides: [authRepositoryProvider.overrideWithValue(repository)],
  );
}

class _FakeAuthRepository implements AuthRepository {
  _FakeAuthRepository({this.sendCompleter});

  final Completer<VerificationCodeDelivery>? sendCompleter;
  int sendCallCount = 0;

  @override
  Future<VerificationCodeDelivery> sendVerificationCode(String phoneNumber) {
    sendCallCount++;
    return sendCompleter?.future ??
        Future.value(const VerificationCodeDelivery(testCode: '123456'));
  }

  @override
  Future<bool> verifyVerificationCode({
    required String phoneNumber,
    required String verificationCode,
  }) async {
    return verificationCode == '123456';
  }
}
