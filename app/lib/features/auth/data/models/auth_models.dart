/// 서버 응답(JSON)을 그대로 담는 Model. Domain에는 Repository가 변환해 전달한다.
class SocialLoginModel {
  const SocialLoginModel({
    required this.isNewUser,
    required this.onboardingStatus,
    this.accessToken,
    this.refreshToken,
    this.onboardingToken,
  });

  factory SocialLoginModel.fromJson(Map<String, dynamic> json) {
    return SocialLoginModel(
      isNewUser: json['isNewUser'] == true,
      onboardingStatus: json['onboardingStatus'] as String,
      accessToken: json['accessToken'] as String?,
      refreshToken: json['refreshToken'] as String?,
      onboardingToken: json['onboardingToken'] as String?,
    );
  }

  final bool isNewUser;
  final String onboardingStatus;
  final String? accessToken;
  final String? refreshToken;
  final String? onboardingToken;

  bool get isOnboardingCompleted => onboardingStatus == 'COMPLETED';
}

class PhoneVerificationModel {
  const PhoneVerificationModel({required this.verificationId});

  factory PhoneVerificationModel.fromJson(Map<String, dynamic> json) {
    return PhoneVerificationModel(
      verificationId: json['verificationId'] as String,
    );
  }

  final String verificationId;
}

class PhoneConfirmationModel {
  const PhoneConfirmationModel({required this.verificationToken});

  factory PhoneConfirmationModel.fromJson(Map<String, dynamic> json) {
    return PhoneConfirmationModel(
      verificationToken: json['verificationToken'] as String,
    );
  }

  final String verificationToken;
}

class OnboardingResultModel {
  const OnboardingResultModel({
    required this.accessToken,
    required this.refreshToken,
    this.proCode,
  });

  factory OnboardingResultModel.fromJson(Map<String, dynamic> json) {
    return OnboardingResultModel(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      proCode: json['proCode'] as String?,
    );
  }

  final String accessToken;
  final String refreshToken;
  final String? proCode;
}
