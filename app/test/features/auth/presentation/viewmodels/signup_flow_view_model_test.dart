import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:swingmate/features/auth/data/repositories/dev_social_credential_source.dart';
import 'package:swingmate/features/auth/di/providers/auth_providers.dart';
import 'package:swingmate/features/auth/di/providers/signup_flow_providers.dart';
import 'package:swingmate/features/auth/domain/entities/auth_exception.dart';
import 'package:swingmate/features/auth/domain/entities/golf_experience.dart';
import 'package:swingmate/features/auth/domain/entities/lesson_interest.dart';
import 'package:swingmate/features/auth/domain/entities/lesson_weekday.dart';
import 'package:swingmate/features/auth/domain/entities/social_provider.dart';
import 'package:swingmate/features/auth/domain/entities/verification_code_delivery.dart';
import 'package:swingmate/features/auth/domain/repositories/auth_repository.dart';
import 'package:swingmate/features/auth/presentation/helpers/signup_messages.dart';
import 'package:swingmate/features/auth/presentation/states/signup_flow_state.dart';

import '../../../../support/fake_auth_repository.dart';

void main() {
  group('SignupFlowViewModel', () {
    test('reset clears data from a previous signup attempt', () {
      final container = _createContainer(FakeAuthRepository());
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
      final container = _createContainer(FakeAuthRepository());
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

    test(
      'keeps common profile data and clears role-specific data on role change',
      () {
        final container = _createContainer(FakeAuthRepository());
        addTearDown(container.dispose);
        final viewModel = container.read(signupFlowViewModelProvider.notifier);

        viewModel
          ..selectRole(SignupRole.member)
          ..updateName('홍길동')
          ..updatePhoneNumber('01012345678')
          ..toggleInterest('드라이버')
          ..selectRole(SignupRole.pro);

        var state = container.read(signupFlowViewModelProvider);
        expect(state.name, '홍길동');
        expect(state.phoneNumber, '01012345678');
        expect(state.member, const MemberSignupDraft());

        viewModel
          ..updateProIntroduction('KPGA 프로입니다.')
          ..selectRole(SignupRole.member);

        state = container.read(signupFlowViewModelProvider);
        expect(state.name, '홍길동');
        expect(state.phoneNumber, '01012345678');
        expect(state.pro, const ProSignupDraft());
      },
    );

    test('blocks duplicate verification-code requests', () async {
      final repository = FakeAuthRepository(
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
      final container = _createContainer(FakeAuthRepository());
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

    test(
      'signs in with the dev social token and reports onboarding state',
      () async {
        final repository = FakeAuthRepository();
        final container = _createContainer(repository);
        addTearDown(container.dispose);

        final result = await container
            .read(signupFlowViewModelProvider.notifier)
            .signInWithSocial(SocialProvider.kakao);

        expect(result?.isOnboardingCompleted, isFalse);
        expect(repository.signedInProvider, SocialProvider.kakao);
        expect(repository.signedInToken, 'kakao-dev-user');
        final state = container.read(signupFlowViewModelProvider);
        expect(state.submissionAction, SubmissionAction.idle);
        expect(state.submissionFailure, isNull);
      },
    );

    test('maps sign-in failures to a submission failure', () async {
      final container = _createContainer(
        FakeAuthRepository(
          error: const AuthException(
            AuthFailureReason.socialProviderUnavailable,
          ),
        ),
      );
      addTearDown(container.dispose);

      final result = await container
          .read(signupFlowViewModelProvider.notifier)
          .signInWithSocial(SocialProvider.google);

      expect(result, isNull);
      expect(
        container.read(signupFlowViewModelProvider).submissionFailure,
        SubmissionFailure.providerUnavailable,
      );
    });

    test('treats a cancelled social login as a cancellation', () async {
      final container = _createContainer(
        FakeAuthRepository(
          error: const AuthException(AuthFailureReason.cancelled),
        ),
      );
      addTearDown(container.dispose);

      final result = await container
          .read(signupFlowViewModelProvider.notifier)
          .signInWithSocial(SocialProvider.kakao);

      expect(result, isNull);
      expect(
        container.read(signupFlowViewModelProvider).submissionFailure,
        SubmissionFailure.cancelled,
      );
    });

    test('submits member signup with domain values', () async {
      final repository = FakeAuthRepository();
      final container = _createContainer(repository);
      addTearDown(container.dispose);
      final viewModel = container.read(signupFlowViewModelProvider.notifier)
        ..selectRole(SignupRole.member)
        ..updateName('홍길동')
        ..updatePhoneNumber('01012345678')
        ..toggleInterest('초보')
        ..toggleInterest('퍼팅')
        ..selectExperience('6개월 ~ 3년');

      expect(await viewModel.completeMemberSignup(), isTrue);

      final registration = repository.memberRegistration!;
      expect(registration.name, '홍길동');
      expect(registration.phoneNumber, '01012345678');
      expect(registration.lessonInterests, {
        LessonInterest.beginner,
        LessonInterest.putting,
      });
      expect(registration.golfExperience, GolfExperience.months6To3Years);
    });

    test('does not submit member signup without a golf experience', () async {
      final repository = FakeAuthRepository();
      final container = _createContainer(repository);
      addTearDown(container.dispose);
      final viewModel = container.read(signupFlowViewModelProvider.notifier)
        ..selectRole(SignupRole.member)
        ..toggleInterest('초보');

      expect(await viewModel.completeMemberSignup(), isFalse);
      expect(repository.memberRegistration, isNull);
      expect(
        container.read(signupFlowViewModelProvider).submissionFailure,
        SubmissionFailure.invalidInput,
      );
    });

    test('submits pro signup with shared or per-day lesson times', () async {
      final repository = FakeAuthRepository();
      final container = _createContainer(repository);
      addTearDown(container.dispose);
      final viewModel = container.read(signupFlowViewModelProvider.notifier)
        ..selectRole(SignupRole.pro)
        ..updateName('김프로')
        ..updatePhoneNumber('01087654321')
        ..updateProIntroduction('KPGA 프로입니다.')
        ..updateProCareer(0, ' KPGA 투어 프로 ')
        ..addProCareer()
        ..updateProAvailability(
          selectedDays: {'수', '월'},
          sharedRanges: const [
            LessonTimeRangeInput(start: '09:00', end: '13:00'),
            LessonTimeRangeInput(start: '18:00', end: '22:30'),
          ],
          dayRanges: const {
            '월': [LessonTimeRangeInput(start: '10:00', end: '11:00')],
          },
          isDaySpecific: false,
        );

      expect(await viewModel.completeProSignup(), isTrue);

      final registration = repository.proRegistration!;
      expect(registration.careers, ['KPGA 투어 프로']);
      expect(registration.availability.map((day) => day.weekday), [
        LessonWeekday.monday,
        LessonWeekday.wednesday,
      ]);
      expect(
        registration.availability.first.timeRanges.map((r) => r.startMinutes),
        [540, 1080],
      );
      expect(registration.availability.first.timeRanges.last.endMinutes, 1350);

      viewModel.updateProAvailability(
        selectedDays: {'월'},
        sharedRanges: const [],
        dayRanges: const {
          '월': [LessonTimeRangeInput(start: '10:00', end: '11:00')],
        },
        isDaySpecific: true,
      );
      await viewModel.completeProSignup();
      final perDay = repository.proRegistration!.availability.single.timeRanges;
      expect(perDay.single.startMinutes, 600);
      expect(perDay.single.endMinutes, 660);
    });

    test('keeps the failure reason when signup completion fails', () async {
      final repository = FakeAuthRepository(
        error: const AuthException(AuthFailureReason.phoneAlreadyInUse),
      );
      final container = _createContainer(repository);
      addTearDown(container.dispose);
      final viewModel = container.read(signupFlowViewModelProvider.notifier)
        ..toggleInterest('초보')
        ..selectExperience('7년 이상');

      expect(await viewModel.completeMemberSignup(), isFalse);
      final state = container.read(signupFlowViewModelProvider);
      expect(state.submissionFailure, SubmissionFailure.phoneAlreadyInUse);
      expect(state.submissionAction, SubmissionAction.idle);
    });

    test('shows server-side limits as verification failures', () async {
      final container = _createContainer(
        FakeAuthRepository(
          error: const AuthException(AuthFailureReason.sendLimitExceeded),
        ),
      );
      addTearDown(container.dispose);
      final viewModel = container.read(signupFlowViewModelProvider.notifier)
        ..updatePhoneNumber('01012345678');

      expect(await viewModel.sendVerificationCode(), isNull);
      expect(
        container.read(signupFlowViewModelProvider).verificationFailure,
        VerificationFailure.tooManyRequests,
      );

      expect(await viewModel.verifyVerificationCode(), isFalse);
    });
  });
}

ProviderContainer _createContainer(AuthRepository repository) {
  return ProviderContainer(
    overrides: [
      authRepositoryProvider.overrideWithValue(repository),
      socialCredentialSourceProvider.overrideWithValue(
        const DevSocialCredentialSource(),
      ),
    ],
  );
}
