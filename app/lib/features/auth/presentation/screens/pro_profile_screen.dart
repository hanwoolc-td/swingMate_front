import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:swingmate/app/router/app_routes.dart';
import 'package:swingmate/app/theme/app_colors.dart';
import 'package:swingmate/features/auth/di/providers/signup_flow_providers.dart';
import 'package:swingmate/features/auth/presentation/helpers/signup_messages.dart';
import 'package:swingmate/features/auth/presentation/states/signup_flow_state.dart';
import 'package:swingmate/features/auth/presentation/widgets/onboarding_header.dart';
import 'package:swingmate/features/auth/presentation/widgets/profile_field.dart';
import 'package:swingmate/features/auth/presentation/widgets/profile_photo_placeholder.dart';

/// Figma 302:17963 — 프로가 회원에게 자신을 소개하는 가입 화면입니다.
class ProProfileScreen extends ConsumerStatefulWidget {
  const ProProfileScreen({super.key});

  @override
  ConsumerState<ProProfileScreen> createState() => _ProProfileScreenState();
}

class _ProProfileScreenState extends ConsumerState<ProProfileScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _requestButtonFocusNode = FocusNode();
  bool _phoneCompletionHandled = false;

  @override
  void initState() {
    super.initState();
    final signupState = ref.read(signupFlowViewModelProvider);
    _nameController.text = signupState.name;
    _phoneController.text = signupState.phoneNumber;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _requestButtonFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final verificationAction = ref.watch(
      signupFlowViewModelProvider.select((state) => state.verificationAction),
    );
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
                          '회원들에게 자신을\n소개해보세요.',
                          style: TextStyle(
                            color: AppColors.ink,
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            height: 36 / 24,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          '프로필 사진과 기본 정보를 입력해 주세요.',
                          style: TextStyle(
                            color: AppColors.secondaryText,
                            fontSize: 18,
                            height: 28 / 18,
                          ),
                        ),
                        const SizedBox(height: 32),
                        const Text(
                          '프로필 사진',
                          style: TextStyle(
                            color: AppColors.ink,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ProfilePhotoPlaceholder(onTap: _showPhotoComingSoon),
                        const SizedBox(height: 32),
                        ProfileField(
                          label: '이름',
                          controller: _nameController,
                          hintText: '예) 홍길동',
                          fillColor: AppColors.roleCardBackground,
                          onChanged: ref
                              .read(signupFlowViewModelProvider.notifier)
                              .updateName,
                        ),
                        const SizedBox(height: 32),
                        ProfileField(
                          label: '전화번호',
                          controller: _phoneController,
                          hintText: '번호만 입력해주세요.',
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          maxLength: 11,
                          fillColor: AppColors.roleCardBackground,
                          onChanged: _handlePhoneChanged,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(21.5, 0, 21.5, 24),
                  child: SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: FilledButton(
                      focusNode: _requestButtonFocusNode,
                      onPressed:
                          verificationAction == VerificationAction.sending
                          ? null
                          : _requestVerificationCode,
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
                      child: verificationAction == VerificationAction.sending
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.surface,
                              ),
                            )
                          : const Text('인증번호 받기'),
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

  void _goBack() {
    if (context.canPop()) {
      context.pop();
      return;
    }

    context.goNamed(AppRoutes.roleSelectionName);
  }

  void _showPhotoComingSoon() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('프로필 사진 등록은 다음 단계에서 연결합니다.')));
  }

  void _handlePhoneChanged(String phoneNumber) {
    ref
        .read(signupFlowViewModelProvider.notifier)
        .updatePhoneNumber(phoneNumber);

    if (phoneNumber.length < 11) {
      _phoneCompletionHandled = false;
      return;
    }
    if (_phoneCompletionHandled) return;

    _phoneCompletionHandled = true;
    FocusScope.of(context).unfocus();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _requestButtonFocusNode.requestFocus();
    });
  }

  Future<void> _requestVerificationCode() async {
    final signupViewModel = ref.read(signupFlowViewModelProvider.notifier);
    signupViewModel
      ..updateName(_nameController.text)
      ..updatePhoneNumber(_phoneController.text);

    final validationError = signupViewModel.validateProfile();
    if (validationError != null) {
      _showValidationMessage(validationError.message);
      return;
    }

    final delivery = await signupViewModel.sendVerificationCode();
    if (!mounted) {
      return;
    }
    if (delivery == null) {
      _showValidationMessage(
        ref.read(signupFlowViewModelProvider).verificationFailure?.message ??
            '인증번호를 보내지 못했습니다.',
      );
      return;
    }

    context.pushNamed(AppRoutes.phoneVerificationName);
  }

  void _showValidationMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}
