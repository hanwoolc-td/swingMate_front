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
    VerificationFailure.phoneAlreadyInUse => '이미 다른 계정에서 사용 중인 번호입니다.',
    VerificationFailure.tooManyRequests => '인증번호 요청이 너무 많습니다. 잠시 후 다시 시도해주세요.',
    VerificationFailure.attemptsExceeded =>
      '인증 시도 횟수를 초과했습니다. 인증번호를 다시 요청해주세요.',
  };
}

extension SubmissionFailureMessage on SubmissionFailure {
  String get message => switch (this) {
    SubmissionFailure.network => '서버에 연결하지 못했습니다. 네트워크를 확인해주세요.',
    SubmissionFailure.invalidSocialToken => '로그인 정보를 확인하지 못했습니다. 다시 시도해주세요.',
    SubmissionFailure.providerUnavailable =>
      '소셜 로그인 서비스에 연결할 수 없습니다. 잠시 후 다시 시도해주세요.',
    SubmissionFailure.phoneAlreadyInUse => '이미 다른 계정에서 사용 중인 번호입니다.',
    SubmissionFailure.verificationExpired => '휴대폰 인증이 만료되었습니다. 처음부터 다시 인증해주세요.',
    SubmissionFailure.invalidInput => '입력한 정보를 확인해주세요.',
    SubmissionFailure.unknown => '일시적인 오류가 발생했습니다. 잠시 후 다시 시도해주세요.',
  };
}
