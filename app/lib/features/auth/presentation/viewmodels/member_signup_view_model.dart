import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swingmate/features/auth/di/providers/auth_providers.dart';
import 'package:swingmate/features/auth/domain/entities/verification_code_delivery.dart';
import 'package:swingmate/features/auth/presentation/states/member_signup_state.dart';

class MemberSignupViewModel extends Notifier<MemberSignupState> {
  static const _verificationDuration = Duration(minutes: 3);
  Timer? _verificationTimer;

  @override
  MemberSignupState build() {
    ref.onDispose(() => _verificationTimer?.cancel());
    return const MemberSignupState();
  }

  void updateName(String value) {
    state = state.copyWith(name: value, nameError: null);
  }

  void updatePhoneNumber(String value) {
    state = state.copyWith(phoneNumber: value, phoneNumberError: null);
  }

  void updateVerificationCode(String value) {
    state = state.copyWith(
      verificationCode: value,
      verificationCodeError: null,
    );
  }

  Future<VerificationCodeDelivery?> sendVerificationCode() async {
    state = state.copyWith(
      isSendingVerificationCode: true,
      verificationError: null,
    );

    try {
      final delivery = await ref
          .read(authRepositoryProvider)
          .sendVerificationCode(_normalizePhoneNumber(state.phoneNumber));
      state = state.copyWith(
        isSendingVerificationCode: false,
        verificationTestCode: delivery.testCode,
        verificationRemaining: _verificationDuration,
      );
      _startVerificationTimer();
      return delivery;
    } catch (_) {
      state = state.copyWith(
        isSendingVerificationCode: false,
        verificationError: '인증번호를 보내지 못했습니다. 잠시 후 다시 시도해주세요.',
      );
      return null;
    }
  }

  Future<VerificationCodeDelivery?> resendVerificationCode() {
    return sendVerificationCode();
  }

  Future<bool> verifyVerificationCode() async {
    if (state.verificationRemaining == Duration.zero) {
      state = state.copyWith(
        verificationError: '인증 시간이 만료되었습니다. 인증번호를 다시 요청해주세요.',
      );
      return false;
    }

    state = state.copyWith(
      isVerifyingVerificationCode: true,
      verificationError: null,
    );

    try {
      final isValid = await ref
          .read(authRepositoryProvider)
          .verifyVerificationCode(
            phoneNumber: _normalizePhoneNumber(state.phoneNumber),
            verificationCode: state.verificationCode,
          );
      state = state.copyWith(
        isVerifyingVerificationCode: false,
        verificationError: isValid ? null : '인증번호가 일치하지 않습니다.',
      );
      return isValid;
    } catch (_) {
      state = state.copyWith(
        isVerifyingVerificationCode: false,
        verificationError: '인증번호를 확인하지 못했습니다. 잠시 후 다시 시도해주세요.',
      );
      return false;
    }
  }

  void _startVerificationTimer() {
    _verificationTimer?.cancel();
    _verificationTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (state.verificationRemaining == Duration.zero) {
        _verificationTimer?.cancel();
        return;
      }

      state = state.copyWith(
        verificationRemaining:
            state.verificationRemaining - const Duration(seconds: 1),
      );
    });
  }

  void updateProCode(String value) {
    state = state.copyWith(proCode: value, proCodeError: null);
  }

  void toggleInterest(String interest) {
    final interests = {...state.selectedInterests};
    if (!interests.add(interest)) {
      interests.remove(interest);
    }

    state = state.copyWith(selectedInterests: interests, interestsError: null);
  }

  void selectExperience(String experience) {
    state = state.copyWith(
      selectedExperience: experience,
      experienceError: null,
    );
  }

  String? validateProfile() {
    final name = state.name.trim();
    final phoneNumber = _normalizePhoneNumber(state.phoneNumber);
    String? nameError;
    String? phoneNumberError;

    if (name.isEmpty) {
      nameError = '이름을 입력해주세요.';
    } else if (!RegExp(r'^[가-힣A-Za-z]{2,}$').hasMatch(name)) {
      nameError = '이름은 한글 또는 영문 2글자 이상 입력해주세요.';
    }

    if (!RegExp(r'^01\d{9}$').hasMatch(phoneNumber)) {
      phoneNumberError = '휴대폰 번호는 숫자 11자리로 입력해주세요.';
    }

    state = state.copyWith(
      name: name,
      phoneNumber: phoneNumber,
      nameError: nameError,
      phoneNumberError: phoneNumberError,
    );

    if (nameError != null) {
      return nameError;
    }
    return phoneNumberError;
  }

  String? validateVerificationCode() {
    final code = state.verificationCode.trim();
    final error = RegExp(r'^\d{6}$').hasMatch(code)
        ? null
        : '인증번호 6자리를 입력해주세요.';
    state = state.copyWith(
      verificationCode: code,
      verificationCodeError: error,
    );
    return error;
  }

  String? validateLessonPreferences() {
    final interestsError = state.selectedInterests.isEmpty
        ? '관심 레슨 분야를 하나 이상 선택해주세요.'
        : null;
    final experienceError = state.selectedExperience == null
        ? '골프 경력을 선택해주세요.'
        : null;
    state = state.copyWith(
      interestsError: interestsError,
      experienceError: experienceError,
    );
    return interestsError ?? experienceError;
  }

  String? validateProCode() {
    final code = state.proCode.trim();
    final error = code.isEmpty ? '프로 코드를 입력해주세요.' : null;
    state = state.copyWith(proCode: code, proCodeError: error);
    return error;
  }

  String _normalizePhoneNumber(String value) {
    return value.replaceAll(RegExp(r'[\s-]'), '');
  }
}
