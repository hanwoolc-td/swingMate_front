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
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -6.0), weight: 25),
      TweenSequenceItem(tween: Tween(begin: -6.0, end: 6.0), weight: 35),
      TweenSequenceItem(tween: Tween(begin: 6.0, end: 0.0), weight: 40),
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedBuilder(
          animation: _errorOffsetAnimation,
          builder: (context, child) => Transform.translate(
            offset: Offset(_errorOffsetAnimation.value, 0),
            child: child,
          ),
          child: SizedBox(
            height: 50,
            child: Stack(
              children: [
                Row(
                  children: List.generate(
                    6,
                    (index) => Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(right: index == 5 ? 0 : 8),
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => _focusAt(index),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: AppColors.selectionCardBackground,
                              borderRadius: BorderRadius.circular(8),
                              border: isError
                                  ? Border.all(color: AppColors.required)
                                  : null,
                            ),
                            child: Center(
                              child: Text(
                                index < widget.controller.text.length
                                    ? widget.controller.text[index]
                                    : '',
                                style: const TextStyle(
                                  color: AppColors.ink,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: IgnorePointer(
                    child: TextField(
                      controller: widget.controller,
                      focusNode: _focusNode,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      showCursor: false,
                      style: const TextStyle(color: Colors.transparent),
                      maxLength: 6,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        _ReplaceWhenFullFormatter(),
                      ],
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        counterText: '',
                        contentPadding: EdgeInsets.zero,
                      ),
                      onChanged: _handleChanged,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (isError) ...[
          const SizedBox(height: 12),
          Text(
            widget.errorText!,
            style: const TextStyle(color: AppColors.required, fontSize: 14),
          ),
        ],
      ],
    );
  }

  void _focusAt(int index) {
    final codeLength = widget.controller.text.length;
    final selectionStart = index.clamp(0, codeLength).toInt();
    final selectionEnd = index < codeLength ? index + 1 : selectionStart;
    widget.controller.selection = TextSelection(
      baseOffset: selectionStart,
      extentOffset: selectionEnd,
    );
    _focusNode.requestFocus();
  }

  void _handleChanged(String value) {
    final previousLength = _previousCodeLength;
    _previousCodeLength = value.length;
    setState(() {});
    widget.onChanged?.call(value);

    if (previousLength < 6 && value.length == 6) {
      widget.onCompleted?.call();
    }
  }
}

class _ReplaceWhenFullFormatter extends TextInputFormatter {
  const _ReplaceWhenFullFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (oldValue.text.length != 6 ||
        newValue.text.length != 7 ||
        !oldValue.selection.isCollapsed) {
      return newValue;
    }

    final index = oldValue.selection.baseOffset;
    if (index >= oldValue.text.length) return oldValue;

    final insertedDigit = newValue.text[index];
    final updatedText =
        '${oldValue.text.substring(0, index)}$insertedDigit${oldValue.text.substring(index + 1)}';
    return TextEditingValue(
      text: updatedText,
      selection: TextSelection.collapsed(offset: index + 1),
    );
  }
}
