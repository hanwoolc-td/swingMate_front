import 'package:swingmate/features/auth/presentation/states/signup_flow_state.dart';

enum SignupValidationError {
  nameRequired,
  invalidName,
  invalidPhoneNumber,
  invalidVerificationCode,
  interestsRequired,
  experienceRequired,
  proCodeRequired,
  proIntroductionRequired,
  proCareerRequired,
  lessonDaysRequired,
  lessonTimeRequired,
  invalidLessonTimeRange,
}

extension SignupValidationErrorMessage on SignupValidationError {
  String get message => switch (this) {
    SignupValidationError.nameRequired => '이름을 입력해주세요.',
    SignupValidationError.invalidName => '이름은 한글 또는 영문 2글자 이상 입력해주세요.',
    SignupValidationError.invalidPhoneNumber => '휴대폰 번호는 숫자 11자리로 입력해주세요.',
    SignupValidationError.invalidVerificationCode => '인증번호 6자리를 입력해주세요.',
    SignupValidationError.interestsRequired => '관심 레슨 분야를 하나 이상 선택해주세요.',
    SignupValidationError.experienceRequired => '골프 경력을 선택해주세요.',
    SignupValidationError.proCodeRequired => '프로 코드를 입력해주세요.',
    SignupValidationError.proIntroductionRequired => '프로 소개를 입력해주세요.',
    SignupValidationError.proCareerRequired => '경력을 하나 이상 입력해주세요.',
    SignupValidationError.lessonDaysRequired => '레슨 가능 요일을 하나 이상 선택해주세요.',
    SignupValidationError.lessonTimeRequired => '시작 시간과 종료 시간을 모두 선택해주세요.',
    SignupValidationError.invalidLessonTimeRange => '종료 시간은 시작 시간보다 늦어야 합니다.',
  };
}

extension VerificationFailureMessage on VerificationFailure {
  String get message => switch (this) {
    VerificationFailure.requestFailed => '인증번호를 보내지 못했습니다. 잠시 후 다시 시도해주세요.',
    VerificationFailure.expired => '인증 시간이 만료되었습니다. 인증번호를 다시 요청해주세요.',
    VerificationFailure.codeMismatch => '인증번호가 일치하지 않습니다.',
    VerificationFailure.verificationFailed =>
      '인증번호를 확인하지 못했습니다. 잠시 후 다시 시도해주세요.',
  };
}
