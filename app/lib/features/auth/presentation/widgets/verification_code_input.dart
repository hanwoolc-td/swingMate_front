import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:swingmate/app/theme/app_colors.dart';

class VerificationCodeInput extends StatefulWidget {
  const VerificationCodeInput({
    required this.controller,
    this.onCompleted,
    super.key,
  });

  final TextEditingController controller;
  final VoidCallback? onCompleted;

  @override
  State<VerificationCodeInput> createState() => _VerificationCodeInputState();
}

class _VerificationCodeInputState extends State<VerificationCodeInput> {
  late final List<TextEditingController> _digitControllers;
  late final List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _digitControllers = List.generate(6, (_) => TextEditingController());
    _focusNodes = List.generate(6, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (final controller in _digitControllers) {
      controller.dispose();
    }
    for (final focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Row(
        children: List.generate(
          6,
          (index) => Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: index == 5 ? 0 : 8),
              child: Semantics(
                textField: true,
                label: '인증번호 ${index + 1}번째 자리',
                child: TextField(
                  controller: _digitControllers[index],
                  focusNode: _focusNodes[index],
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  textInputAction: index == 5
                      ? TextInputAction.done
                      : TextInputAction.next,
                  maxLength: 1,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  style: const TextStyle(
                    color: AppColors.ink,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                  decoration: InputDecoration(
                    counterText: '',
                    filled: true,
                    fillColor: AppColors.roleCardBackground,
                    contentPadding: EdgeInsets.zero,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: AppColors.borderSubtle,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: AppColors.borderSubtle,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppColors.ink),
                    ),
                  ),
                  onChanged: (value) => _handleChanged(index, value),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleChanged(int index, String value) {
    if (value.isNotEmpty && index < _focusNodes.length - 1) {
      _focusNodes[index + 1].requestFocus();
    }

    if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }

    final code = _digitControllers.map((controller) => controller.text).join();
    widget.controller.value = TextEditingValue(
      text: code,
      selection: TextSelection.collapsed(offset: code.length),
    );

    if (_digitControllers.every((controller) => controller.text.isNotEmpty)) {
      widget.onCompleted?.call();
    }
  }
}
