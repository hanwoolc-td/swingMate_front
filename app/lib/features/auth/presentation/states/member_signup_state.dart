import 'package:freezed_annotation/freezed_annotation.dart';

part 'member_signup_state.freezed.dart';

@freezed
abstract class MemberSignupState with _$MemberSignupState {
  const factory MemberSignupState({
    @Default('') String name,
    @Default('') String phoneNumber,
    @Default('') String verificationCode,
    @Default(Duration.zero) Duration verificationRemaining,
    @Default(false) bool isSendingVerificationCode,
    @Default(false) bool isVerifyingVerificationCode,
    String? verificationTestCode,
    String? verificationError,
    @Default(<String>{}) Set<String> selectedInterests,
    String? selectedExperience,
    @Default('') String proCode,
    String? nameError,
    String? phoneNumberError,
    String? verificationCodeError,
    String? interestsError,
    String? experienceError,
    String? proCodeError,
  }) = _MemberSignupState;
}
