import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swingmate/features/auth/di/providers/auth_providers.dart';
import 'package:swingmate/features/auth/domain/entities/verification_code_delivery.dart';
import 'package:swingmate/features/auth/presentation/helpers/signup_messages.dart';
import 'package:swingmate/features/auth/presentation/states/signup_flow_state.dart';

class SignupFlowViewModel extends Notifier<SignupFlowState> {
  static const _verificationDuration = Duration(minutes: 3);
  Timer? _verificationTimer;
  int _requestGeneration = 0;

  @override
  SignupFlowState build() {
    ref.onDispose(() => _verificationTimer?.cancel());
    return const SignupFlowState();
  }

  void reset() {
    _requestGeneration++;
    _verificationTimer?.cancel();
    state = const SignupFlowState();
  }

  void selectRole(SignupRole role) {
    if (state.role == role) return;
    _requestGeneration++;
    _verificationTimer?.cancel();
    state = state.copyWith(
      role: role,
      verificationCode: '',
      verificationRemaining: Duration.zero,
      verificationAction: VerificationAction.idle,
      verificationTestCode: null,
      verificationFailure: null,
      member: role == SignupRole.member
          ? state.member
          : const MemberSignupDraft(),
      pro: role == SignupRole.pro ? state.pro : const ProSignupDraft(),
    );
  }

  void updateName(String value) {
    state = state.copyWith(name: value);
  }

  void updatePhoneNumber(String value) {
    state = state.copyWith(phoneNumber: value);
  }

  void updateVerificationCode(String value) {
    state = state.copyWith(verificationCode: value, verificationFailure: null);
  }

  Future<VerificationCodeDelivery?> sendVerificationCode() async {
    if (state.verificationAction != VerificationAction.idle) return null;

    final generation = ++_requestGeneration;
    final phoneNumber = _normalizePhoneNumber(state.phoneNumber);
    state = state.copyWith(
      verificationAction: VerificationAction.sending,
      verificationFailure: null,
    );

    try {
      final delivery = await ref
          .read(authRepositoryProvider)
          .sendVerificationCode(phoneNumber);
      if (generation != _requestGeneration) return null;

      state = state.copyWith(
        verificationAction: VerificationAction.idle,
        verificationTestCode: delivery.testCode,
        verificationRemaining: _verificationDuration,
      );
      _startVerificationTimer();
      return delivery;
    } catch (_) {
      if (generation != _requestGeneration) return null;
      state = state.copyWith(
        verificationAction: VerificationAction.idle,
        verificationFailure: VerificationFailure.requestFailed,
      );
      return null;
    }
  }

  Future<VerificationCodeDelivery?> resendVerificationCode() {
    return sendVerificationCode();
  }

  Future<bool> verifyVerificationCode() async {
    if (state.verificationAction != VerificationAction.idle) return false;
    if (state.verificationRemaining == Duration.zero) {
      state = state.copyWith(verificationFailure: VerificationFailure.expired);
      return false;
    }

    final generation = ++_requestGeneration;
    final phoneNumber = _normalizePhoneNumber(state.phoneNumber);
    final verificationCode = state.verificationCode;
    state = state.copyWith(
      verificationAction: VerificationAction.verifying,
      verificationFailure: null,
    );

    try {
      final isValid = await ref
          .read(authRepositoryProvider)
          .verifyVerificationCode(
            phoneNumber: phoneNumber,
            verificationCode: verificationCode,
          );
      if (generation != _requestGeneration) return false;

      if (isValid) {
        _verificationTimer?.cancel();
      }

      state = state.copyWith(
        verificationAction: VerificationAction.idle,
        verificationRemaining: isValid
            ? Duration.zero
            : state.verificationRemaining,
        verificationFailure: isValid ? null : VerificationFailure.codeMismatch,
      );
      return isValid;
    } catch (_) {
      if (generation != _requestGeneration) return false;
      state = state.copyWith(
        verificationAction: VerificationAction.idle,
        verificationFailure: VerificationFailure.verificationFailed,
      );
      return false;
    }
  }

  void toggleInterest(String interest) {
    final interests = {...state.member.selectedInterests};
    if (!interests.add(interest)) interests.remove(interest);
    state = state.copyWith.member(selectedInterests: interests);
  }

  void selectExperience(String experience) {
    state = state.copyWith.member(selectedExperience: experience);
  }

  void updateProCode(String value) {
    state = state.copyWith.member(proCode: value);
  }

  void updateProIntroduction(String value) {
    state = state.copyWith.pro(introduction: value);
  }

  void updateProCareer(int index, String value) {
    final careers = [...state.pro.careers];
    if (index < 0 || index >= careers.length) return;
    careers[index] = value;
    state = state.copyWith.pro(careers: careers);
  }

  void addProCareer() {
    state = state.copyWith.pro(careers: [...state.pro.careers, '']);
  }

  void updateProAvailability({
    required Set<String> selectedDays,
    required List<LessonTimeRangeInput> sharedRanges,
    required Map<String, List<LessonTimeRangeInput>> dayRanges,
    required bool isDaySpecific,
  }) {
    state = state.copyWith.pro(
      selectedDays: {...selectedDays},
      sharedRanges: [...sharedRanges],
      dayRanges: {
        for (final entry in dayRanges.entries) entry.key: [...entry.value],
      },
      isDaySpecific: isDaySpecific,
    );
  }

  SignupValidationError? validateProfile() {
    final name = state.name.trim();
    final phoneNumber = _normalizePhoneNumber(state.phoneNumber);
    state = state.copyWith(name: name, phoneNumber: phoneNumber);

    if (name.isEmpty) return SignupValidationError.nameRequired;
    if (!RegExp(r'^[가-힣A-Za-z]{2,}$').hasMatch(name)) {
      return SignupValidationError.invalidName;
    }
    if (!RegExp(r'^01\d{9}$').hasMatch(phoneNumber)) {
      return SignupValidationError.invalidPhoneNumber;
    }
    return null;
  }

  SignupValidationError? validateVerificationCode() {
    final code = state.verificationCode.trim();
    state = state.copyWith(verificationCode: code);
    return RegExp(r'^\d{6}$').hasMatch(code)
        ? null
        : SignupValidationError.invalidVerificationCode;
  }

  SignupValidationError? validateLessonPreferences() {
    if (state.member.selectedInterests.isEmpty) {
      return SignupValidationError.interestsRequired;
    }
    if (state.member.selectedExperience == null) {
      return SignupValidationError.experienceRequired;
    }
    return null;
  }

  SignupValidationError? validateProCode() {
    final code = state.member.proCode.trim();
    state = state.copyWith.member(proCode: code);
    return code.isEmpty ? SignupValidationError.proCodeRequired : null;
  }

  Set<SignupValidationError> validateProCareer() {
    final introduction = state.pro.introduction.trim();
    final careers = state.pro.careers.map((value) => value.trim()).toList();
    state = state.copyWith.pro(introduction: introduction, careers: careers);

    return {
      if (introduction.isEmpty) SignupValidationError.proIntroductionRequired,
      if (careers.every((value) => value.isEmpty))
        SignupValidationError.proCareerRequired,
    };
  }

  SignupValidationError? validateProAvailability() {
    if (state.pro.selectedDays.isEmpty) {
      return SignupValidationError.lessonDaysRequired;
    }

    final ranges = state.pro.isDaySpecific
        ? state.pro.selectedDays.expand(
            (day) => state.pro.dayRanges[day] ?? const <LessonTimeRangeInput>[],
          )
        : state.pro.sharedRanges;
    for (final range in ranges) {
      if (range.start.isEmpty || range.end.isEmpty) {
        return SignupValidationError.lessonTimeRequired;
      }
      final start = _timeToMinutes(range.start);
      final end = _timeToMinutes(range.end);
      if (start == null || end == null || start >= end) {
        return SignupValidationError.invalidLessonTimeRange;
      }
    }
    return null;
  }

  void _startVerificationTimer() {
    _verificationTimer?.cancel();
    _verificationTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (state.verificationRemaining <= Duration.zero) {
        _verificationTimer?.cancel();
        return;
      }
      state = state.copyWith(
        verificationRemaining:
            state.verificationRemaining - const Duration(seconds: 1),
      );
    });
  }

  String _normalizePhoneNumber(String value) {
    return value.replaceAll(RegExp(r'[\s-]'), '');
  }

  int? _timeToMinutes(String value) {
    final parts = value.split(':');
    if (parts.length != 2) return null;
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null || hour > 23 || minute > 59) {
      return null;
    }
    return hour * 60 + minute;
  }
}
