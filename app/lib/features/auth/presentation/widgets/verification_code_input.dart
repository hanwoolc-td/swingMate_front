import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:swingmate/app/theme/app_colors.dart';

class VerificationCodeInput extends StatefulWidget {
  const VerificationCodeInput({
    required this.controller,
    this.errorText,
    this.onCompleted,
    this.onChanged,
    super.key,
  });

  final TextEditingController controller;
  final String? errorText;
  final VoidCallback? onCompleted;
  final ValueChanged<String>? onChanged;

  @override
  State<VerificationCodeInput> createState() => _VerificationCodeInputState();
}

class _VerificationCodeInputState extends State<VerificationCodeInput>
    with SingleTickerProviderStateMixin {
  late final FocusNode _focusNode;
  late final AnimationController _errorAnimationController;
  late final Animation<double> _errorOffsetAnimation;
  late var _previousCodeLength = widget.controller.text.length;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _errorAnimationController = AnimationController(
      duration: const Duration(milliseconds: 360),
      vsync: this,
    );
    _errorOffsetAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: -6.0),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: Tween(begin: -6.0, end: 6.0),
        weight: 35,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 6.0, end: 0.0),
        weight: 40,
      ),
    ]).animate(_errorAnimationController);
  }

  @override
  void didUpdateWidget(covariant VerificationCodeInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.errorText == null && widget.errorText != null) {
      _errorAnimationController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _errorAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isError = widget.errorText != null;
    final borderColor = isError ? AppColors.required : AppColors.borderSubtle;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedBuilder(
          animation: _errorOffsetAnimation,
          builder: (context, child) => Transform.translate(
            offset: Offset(_errorOffsetAnimation.value, 0),
            child: child,
          ),
          child: TextField(
            controller: widget.controller,
            focusNode: _focusNode,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            maxLength: 6,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: _handleChanged,
            style: const TextStyle(
              color: AppColors.ink,
              fontSize: 20,
              fontWeight: FontWeight.w600,
              letterSpacing: 4,
            ),
            decoration: InputDecoration(
              counterText: '',
              hintText: '인증번호 6자리',
              hintStyle: const TextStyle(
                color: AppColors.secondaryText,
                fontSize: 16,
                fontWeight: FontWeight.w400,
                letterSpacing: 0,
              ),
              filled: true,
              fillColor: AppColors.selectionCardBackground,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              border: _border(borderColor),
              enabledBorder: _border(borderColor),
              focusedBorder: _border(
                isError ? AppColors.required : AppColors.ink,
              ),
            ),
          ),
        ),
        if (isError) ...[
          const SizedBox(height: 12),
          Text(
            widget.errorText!,
            style: const TextStyle(
              color: AppColors.required,
              fontSize: 14,
            ),
          ),
        ],
      ],
    );
  }

  OutlineInputBorder _border(Color color) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: BorderSide(color: color),
  );

  void _handleChanged(String value) {
    final previousLength = _previousCodeLength;
    _previousCodeLength = value.length;
    widget.onChanged?.call(value);

    if (previousLength < 6 && value.length == 6) {
      widget.onCompleted?.call();
    }
  }
}
