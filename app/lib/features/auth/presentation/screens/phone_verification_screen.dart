import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:swingmate/app/router/app_routes.dart';
import 'package:swingmate/app/theme/app_colors.dart';
import 'package:swingmate/features/auth/di/providers/member_signup_providers.dart';
import 'package:swingmate/features/auth/presentation/widgets/onboarding_header.dart';
import 'package:swingmate/features/auth/presentation/widgets/verification_code_input.dart';

class PhoneVerificationScreen extends ConsumerStatefulWidget {
  const PhoneVerificationScreen({
    required this.phoneNumber,
    this.isProSignup = false,
    super.key,
  });

  final String phoneNumber;
  final bool isProSignup;

  @override
  ConsumerState<PhoneVerificationScreen> createState() =>
      _PhoneVerificationScreenState();
}

class _PhoneVerificationScreenState
    extends ConsumerState<PhoneVerificationScreen> {
  final _codeController = TextEditingController();
  Key _verificationInputKey = UniqueKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      final testCode = ref
          .read(memberSignupViewModelProvider)
          .verificationTestCode;
      if (testCode != null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('임시 인증번호는 $testCode 입니다.')));
      }
    });
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final signupState = ref.watch(memberSignupViewModelProvider);
    final keyboardHeight = MediaQuery.viewInsetsOf(context).bottom;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 393),
            child: Column(
              children: [
                OnboardingHeader(onBack: _goBack),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(
                      24,
                      40,
                      24,
                      24 + keyboardHeight,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '휴대폰 번호를\n인증해주세요.',
                          style: TextStyle(
                            color: AppColors.ink,
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            height: 36 / 24,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${widget.phoneNumber}로 인증번호를 보냈습니다.',
                          style: const TextStyle(
                            color: AppColors.secondaryText,
                            fontSize: 18,
                            height: 26 / 18,
                          ),
                        ),
                        const SizedBox(height: 32),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            _formatRemaining(signupState.verificationRemaining),
                            style: const TextStyle(
                              color: AppColors.secondaryText,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        VerificationCodeInput(
                          key: _verificationInputKey,
                          controller: _codeController,
                          onCompleted: _hideKeyboard,
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          height: 42,
                          child: TextButton(
                            onPressed: () {
                              _resendCode();
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: AppColors.secondaryText,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              textStyle: const TextStyle(fontSize: 14),
                            ),
                            child: const Text('인증번호 재전송'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  child: SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: FilledButton(
                      onPressed: _verifyCode,
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.action,
                        foregroundColor: AppColors.surface,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      child: const Text('인증하기'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatRemaining(Duration duration) {
    final minutes = duration.inMinutes.toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void _hideKeyboard() {
    FocusScope.of(context).unfocus();
  }

  void _goBack() {
    if (context.canPop()) {
      context.pop();
      return;
    }

    context.goNamed(
      widget.isProSignup
          ? AppRoutes.proProfileName
          : AppRoutes.memberProfileName,
    );
  }

  Future<void> _resendCode() async {
    _codeController.clear();
    setState(() => _verificationInputKey = UniqueKey());
    ref.read(memberSignupViewModelProvider.notifier).updateVerificationCode('');

    final delivery = await ref
        .read(memberSignupViewModelProvider.notifier)
        .resendVerificationCode();
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            delivery == null
                ? '인증번호를 다시 보내지 못했습니다.'
                : '임시 인증번호는 ${delivery.testCode} 입니다.',
          ),
        ),
      );
  }

  Future<void> _verifyCode() async {
    final signupViewModel = ref.read(memberSignupViewModelProvider.notifier);
    signupViewModel.updateVerificationCode(_codeController.text);
    final validationError = signupViewModel.validateVerificationCode();
    if (validationError != null) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(validationError)));
      return;
    }

    final isVerified = await signupViewModel.verifyVerificationCode();
    if (!mounted) {
      return;
    }
    if (!isVerified) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              ref.read(memberSignupViewModelProvider).verificationError ??
                  '인증번호가 일치하지 않습니다.',
            ),
          ),
        );
      return;
    }

    context.pushNamed(
      widget.isProSignup
          ? AppRoutes.proCareerName
          : AppRoutes.lessonPreferencesName,
    );
  }
}
