import 'package:freezed_annotation/freezed_annotation.dart';

part 'signup_flow_state.freezed.dart';

enum SignupRole { member, pro }

enum VerificationAction { idle, sending, verifying }

enum VerificationFailure {
  requestFailed,
  expired,
  codeMismatch,
  verificationFailed,
  phoneAlreadyInUse,
  tooManyRequests,
  attemptsExceeded,
}

enum SubmissionAction { idle, signingIn, completing }

enum SubmissionFailure {
  network,
  cancelled,
  invalidSocialToken,
  providerUnavailable,
  phoneAlreadyInUse,
  verificationExpired,
  invalidInput,
  unknown,
}

@freezed
abstract class LessonTimeRangeInput with _$LessonTimeRangeInput {
  const factory LessonTimeRangeInput({
    @Default('') String start,
    @Default('') String end,
  }) = _LessonTimeRangeInput;
}

@freezed
abstract class MemberSignupDraft with _$MemberSignupDraft {
  const factory MemberSignupDraft({
    @Default(<String>{}) Set<String> selectedInterests,
    String? selectedExperience,
    @Default('') String proCode,
  }) = _MemberSignupDraft;
}

@freezed
abstract class ProSignupDraft with _$ProSignupDraft {
  const factory ProSignupDraft({
    @Default('') String introduction,
    @Default(<String>['']) List<String> careers,
    @Default(<String>{'월', '화', '수', '목', '금'}) Set<String> selectedDays,
    @Default(<LessonTimeRangeInput>[
      LessonTimeRangeInput(start: '09:00', end: '13:00'),
      LessonTimeRangeInput(start: '18:00', end: '22:00'),
    ])
    List<LessonTimeRangeInput> sharedRanges,
    @Default(<String, List<LessonTimeRangeInput>>{
      '월': [LessonTimeRangeInput(start: '09:00', end: '18:00')],
      '화': [LessonTimeRangeInput(start: '09:00', end: '18:00')],
      '수': [LessonTimeRangeInput(start: '09:00', end: '18:00')],
      '목': [LessonTimeRangeInput(start: '09:00', end: '18:00')],
      '금': [LessonTimeRangeInput(start: '09:00', end: '18:00')],
      '토': [LessonTimeRangeInput(start: '09:00', end: '18:00')],
      '일': [LessonTimeRangeInput(start: '09:00', end: '18:00')],
    })
    Map<String, List<LessonTimeRangeInput>> dayRanges,
    @Default(false) bool isDaySpecific,
  }) = _ProSignupDraft;
}

@freezed
abstract class SignupFlowState with _$SignupFlowState {
  const factory SignupFlowState({
    SignupRole? role,
    @Default('') String name,
    @Default('') String phoneNumber,
    @Default('') String verificationCode,
    @Default(Duration.zero) Duration verificationRemaining,
    @Default(VerificationAction.idle) VerificationAction verificationAction,
    String? verificationTestCode,
    VerificationFailure? verificationFailure,
    @Default(SubmissionAction.idle) SubmissionAction submissionAction,
    SubmissionFailure? submissionFailure,
    @Default(MemberSignupDraft()) MemberSignupDraft member,
    @Default(ProSignupDraft()) ProSignupDraft pro,
  }) = _SignupFlowState;
}
