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

/// Figma 314:9562 — 프로의 소개와 경력을 입력하는 가입 화면입니다.
class ProCareerScreen extends ConsumerStatefulWidget {
  const ProCareerScreen({super.key});

  @override
  ConsumerState<ProCareerScreen> createState() => _ProCareerScreenState();
}

class _ProCareerScreenState extends ConsumerState<ProCareerScreen> {
  final _introductionController = TextEditingController();
  final _careerControllers = <TextEditingController>[];
  String? _introductionError;
  String? _careerError;

  @override
  void initState() {
    super.initState();
    final draft = ref.read(signupFlowViewModelProvider).pro;
    _introductionController.text = draft.introduction;
    _careerControllers.addAll(
      draft.careers.map((value) => TextEditingController(text: value)),
    );
  }

  @override
  void dispose() {
    _introductionController.dispose();
    for (final controller in _careerControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                        const SizedBox(height: 8),
                        const Text(
                          '자신의 경력을 소개해보세요.',
                          style: TextStyle(
                            color: AppColors.secondaryText,
                            fontSize: 18,
                            height: 28 / 18,
                          ),
                        ),
                        const SizedBox(height: 48),
                        const Text(
                          '프로 소개',
                          style: TextStyle(
                            color: AppColors.ink,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _IntroductionField(
                          controller: _introductionController,
                          errorText: _introductionError,
                          onChanged: (value) {
                            ref
                                .read(signupFlowViewModelProvider.notifier)
                                .updateProIntroduction(value);
                            if (_introductionError != null) {
                              setState(() => _introductionError = null);
                            }
                          },
                        ),
                        const SizedBox(height: 32),
                        const Text(
                          '경력',
                          style: TextStyle(
                            color: AppColors.ink,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 16),
                        for (final (index, controller)
                            in _careerControllers.indexed) ...[
                          _CareerField(
                            controller: controller,
                            onChanged: (value) {
                              ref
                                  .read(signupFlowViewModelProvider.notifier)
                                  .updateProCareer(index, value);
                              if (_careerError != null) {
                                setState(() => _careerError = null);
                              }
                            },
                          ),
                          const SizedBox(height: 12),
                        ],
                        _AddCareerButton(onTap: _addCareer),
                        if (_careerError != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            _careerError!,
                            style: const TextStyle(
                              color: AppColors.required,
                              fontSize: 14,
                            ),
                          ),
                        ],
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
                      onPressed: _continue,
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
                      child: const Text('다음'),
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

    context.goNamed(AppRoutes.phoneVerificationName);
  }

  void _addCareer() {
    ref.read(signupFlowViewModelProvider.notifier).addProCareer();
    setState(() => _careerControllers.add(TextEditingController()));
  }

  void _continue() {
    final signupViewModel = ref.read(signupFlowViewModelProvider.notifier);
    signupViewModel.updateProIntroduction(_introductionController.text);
    for (final (index, controller) in _careerControllers.indexed) {
      signupViewModel.updateProCareer(index, controller.text);
    }
    final errors = signupViewModel.validateProCareer();
    final introductionError =
        errors.contains(SignupValidationError.proIntroductionRequired)
        ? SignupValidationError.proIntroductionRequired.message
        : null;
    final careerError = errors.contains(SignupValidationError.proCareerRequired)
        ? SignupValidationError.proCareerRequired.message
        : null;

    setState(() {
      _introductionError = introductionError;
      _careerError = careerError;
    });

    if (introductionError != null || careerError != null) {
      return;
    }

    context.pushNamed(AppRoutes.proAvailabilityName);
  }
}

class _IntroductionField extends StatelessWidget {
  const _IntroductionField({
    required this.controller,
    this.errorText,
    this.onChanged,
  });

  final TextEditingController controller;
  final String? errorText;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 132,
          child: TextField(
            controller: controller,
            onChanged: onChanged,
            maxLength: 200,
            maxLines: null,
            expands: true,
            textAlignVertical: TextAlignVertical.top,
            style: const TextStyle(
              color: AppColors.ink,
              fontSize: 16,
              height: 24 / 16,
            ),
            decoration: InputDecoration(
              counterText: '',
              hintText: '간단한 자기소개를 입력해주세요.\n(최대 200자)',
              hintStyle: const TextStyle(
                color: AppColors.navigationInactive,
                fontSize: 16,
                height: 24 / 16,
              ),
              filled: true,
              fillColor: AppColors.roleCardBackground,
              contentPadding: const EdgeInsets.all(16),
              border: _fieldBorder,
              enabledBorder: _borderFor(errorText),
              focusedBorder: _fieldBorder.copyWith(
                borderSide: BorderSide(
                  color: errorText == null ? AppColors.ink : AppColors.required,
                ),
              ),
            ),
          ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: 6),
          Text(
            errorText!,
            style: const TextStyle(color: AppColors.required, fontSize: 14),
          ),
        ],
      ],
    );
  }
}

class _CareerField extends StatelessWidget {
  const _CareerField({required this.controller, this.onChanged});

  final TextEditingController controller;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: const TextStyle(color: AppColors.ink, fontSize: 16),
        decoration: InputDecoration(
          hintText: '예) KPGA 투어 프로',
          hintStyle: const TextStyle(
            color: AppColors.navigationInactive,
            fontSize: 16,
          ),
          filled: true,
          fillColor: AppColors.roleCardBackground,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          border: _fieldBorder,
          enabledBorder: _fieldBorder,
          focusedBorder: _fieldBorder.copyWith(
            borderSide: const BorderSide(color: AppColors.ink),
          ),
        ),
      ),
    );
  }
}

final _fieldBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(8),
  borderSide: const BorderSide(color: AppColors.border),
);

OutlineInputBorder _borderFor(String? errorText) {
  if (errorText == null) {
    return _fieldBorder;
  }

  return _fieldBorder.copyWith(
    borderSide: const BorderSide(color: AppColors.required),
  );
}

class _AddCareerButton extends StatelessWidget {
  const _AddCareerButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '경력 추가',
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: double.infinity,
            height: 40,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
            child: CustomPaint(
              foregroundPainter: _DashedBorderPainter(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(AppAssets.careerAdd),
                  const SizedBox(width: 10),
                  const Text(
                    '경력 추가',
                    style: TextStyle(
                      color: AppColors.secondaryText,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const radius = Radius.circular(12);
    const dash = 5.0;
    const gap = 4.0;
    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(Offset.zero & size, radius));
    final metric = path.computeMetrics().single;
    final paint = Paint()
      ..color = AppColors.dashedBorder
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    for (var distance = 0.0; distance < metric.length; distance += dash + gap) {
      canvas.drawPath(metric.extractPath(distance, distance + dash), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
