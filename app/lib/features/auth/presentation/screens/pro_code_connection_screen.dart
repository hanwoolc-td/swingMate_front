import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:swingmate/app/router/app_routes.dart';
import 'package:swingmate/app/theme/app_colors.dart';
import 'package:swingmate/core/theme/app_assets.dart';
import 'package:swingmate/features/auth/di/providers/signup_flow_providers.dart';
import 'package:swingmate/features/auth/presentation/helpers/signup_messages.dart';
import 'package:swingmate/features/auth/presentation/widgets/onboarding_header.dart';

class ProCodeConnectionScreen extends ConsumerStatefulWidget {
  const ProCodeConnectionScreen({super.key});

  @override
  ConsumerState<ProCodeConnectionScreen> createState() =>
      _ProCodeConnectionScreenState();
}

class _ProCodeConnectionScreenState
    extends ConsumerState<ProCodeConnectionScreen> {
  final _codeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _codeController.text = ref.read(signupFlowViewModelProvider).member.proCode;
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 393),
            child: Stack(
              children: [
                Column(
                  children: [
                    OnboardingHeader(onBack: _goBack),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '프로와 연결해보세요.',
                              style: TextStyle(
                                color: AppColors.ink,
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                height: 32 / 24,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              '프로에게 받은 코드를 입력하거나\nQR을 스캔해주세요.',
                              style: TextStyle(
                                color: AppColors.secondaryText,
                                fontSize: 18,
                                height: 26 / 18,
                              ),
                            ),
                            const SizedBox(height: 32),
                            _buildCodeField(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  left: 24,
                  right: 24,
                  bottom: 24,
                  child: _WideButton(
                    label: '나중에 연결하기',
                    isSecondary: true,
                    onPressed: _skip,
                  ),
                ),
                Positioned(
                  left: 24,
                  right: 24,
                  bottom: _connectButtonBottom,
                  child: _WideButton(label: '연결하기', onPressed: _connect),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  double get _connectButtonBottom {
    final keyboardInset = MediaQuery.of(context).viewInsets.bottom;
    const double defaultBottom = 84.0;
    final double keyboardBottom = keyboardInset + 24.0;

    // 키보드가 내려가는 중에도 하단 버튼과 겹치지 않도록 최소 간격을 유지한다.
    return keyboardBottom > defaultBottom ? keyboardBottom : defaultBottom;
  }

  Widget _buildCodeField() {
    return Column(
      children: [
        TextField(
          controller: _codeController,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            hintText: '프로에게 코드를 요청하세요.',
            hintStyle: const TextStyle(
              color: AppColors.navigationInactive,
              fontSize: 16,
            ),
            filled: true,
            fillColor: AppColors.inputBackground,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.ink),
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 42,
          child: OutlinedButton.icon(
            onPressed: _connectWithQr,
            icon: const SizedBox(
              width: 20,
              height: 20,
              child: Center(child: _QrCodeIcon()),
            ),
            label: const Text('QR로 연결하기'),
            style: OutlinedButton.styleFrom(
              backgroundColor: AppColors.inputBackground,
              foregroundColor: AppColors.ink,
              side: const BorderSide(color: AppColors.borderSubtle),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              textStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _goBack() {
    if (context.canPop()) {
      context.pop();
      return;
    }

    context.goNamed(AppRoutes.lessonPreferencesName);
  }

  void _connect() {
    final signupViewModel = ref.read(signupFlowViewModelProvider.notifier);
    signupViewModel.updateProCode(_codeController.text);
    final validationError = signupViewModel.validateProCode();
    if (validationError != null) {
      _showMessage(validationError.message);
      return;
    }

    context.pushNamed(AppRoutes.proConnectionFailureName);
  }

  void _connectWithQr() {
    context.pushNamed(AppRoutes.proConnectionFailureName);
  }

  void _skip() {
    context.goNamed(AppRoutes.homeName);
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}

class _QrCodeIcon extends StatelessWidget {
  const _QrCodeIcon();

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(AppAssets.qrCode);
  }
}

class _WideButton extends StatelessWidget {
  const _WideButton({
    required this.label,
    required this.onPressed,
    this.isSecondary = false,
  });

  final String label;
  final VoidCallback onPressed;
  final bool isSecondary;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: isSecondary
              ? AppColors.inputBackground
              : AppColors.action,
          foregroundColor: isSecondary ? AppColors.ink : AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: TextStyle(
            fontSize: 18,
            fontWeight: isSecondary ? FontWeight.w500 : FontWeight.w700,
          ),
        ),
        child: Text(label),
      ),
    );
  }
}
